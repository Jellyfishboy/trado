class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  skip_before_action :authenticate_user!

  before_action :check_order_status, only: :show

  before_action :accessible_order, except: [:success, :failure]

  steps :review, :billing, :shipping, :payment, :confirm

  ###################################
  # ORDER VIEW LOGIC
  ###################################
  # Displays the front-end content of each step, with specific methods throughout providing the relevant data
  # Steps include, in this order: review, billing, shipping, payment then confimration
  #
  def show
    @cart = current_cart
    ################
    # Sets current state of the order
    @order.status = step == steps.last ? :active : step
    @order.save(validate: false)
    ################
    case step
    when :review
      Shipatron4000::tier(current_cart, @order) if @order.tiers.nil?
    end
    case step
    when :billing
      @billing_address = @order.bill_address
    end
    case step
    when :shipping
      Shipatron4000::tier(current_cart, @order) if @order.tiers.nil?
      @shipping_address = @order.ship_address
    end
    case step 
    when :payment
      @order.calculate(current_cart, Store::tax_rate)
    end
    case step
    when :confirm
      Payatron4000::Paypal.assign_paypal_token(params[:token], params[:PayerID], @order) if params[:token] && params[:PayerID]
    end
    render_wizard
  end
  ###################################

  ###################################
  # ORDER UPDATE LOGIC
  ###################################
  # When advancing to the next step in the order process, the update method is called
  # Any bespoke business logic in each step is then triggered, for example: updating the address and the order status attribute value
  #
  def update 
    @cart = current_cart
    case step 
    when :billing
      @billing_address = @order.bill_address
      # Update billing attributes
      if @billing_address.update(params[:address])
        # Update order attributes in the form
        unless @order.update(params[:order])
          # if unsuccessful re-render the form with order errors
          render_wizard @order
        else
          # else continue to the next stage
          render_wizard @billing_address
        end
      else
        render_wizard @billing_address
      end  
    end
    case step
    when :shipping
      @shipping_address = @order.ship_address
      # Update billing attributes
      if @shipping_address.update(params[:address])
        # Update order attributes in the form
        unless @order.update(params[:order])
          # if unsuccessful re-render the form with order errors
          render_wizard @order
        else
          # else continue to the next stage
          render_wizard @shipping_address
        end
      else
        render_wizard @shipping_address
      end
    end
    case step
    when :confirm
      if @order.update(params[:order])
        @order.transfer(current_cart)
        redirect_to Payatron4000::Paypal.complete(@order, session)
      else
        render_wizard @order
      end
    end
  end
  ###################################

  ################################### 
  # ORDER PAYMENT TYPES 
  ###################################
  # Prepares the order data and redirects to the PayPal login page to review the order
  # Bespoke PayPal method
  #
  def express
    response = EXPRESS_GATEWAY.setup_purchase(Store::Price.new(@order.gross_amount, 'net').singularize, 
                                              Payatron4000::Paypal.express_setup_options( @order, 
                                                                                          steps, 
                                                                                          current_cart,
                                                                                          request.remote_ip, 
                                                                                          order_build_url(:order_id => @order.id, :id => steps.last), 
                                                                                          order_build_url(:order_id => @order.id, :id => 'payment')
                                              )
    )
    if response.success?
      redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    else
      begin
        Payatron4000::Paypal.failed(response, @order)
      rescue Exception => e
        Rollbar.report_exception(e)
      end
      @order.update_column(:cart_id, nil) 
      redirect_to failure_order_build_url( :order_id => @order.id, :id => 'confirm', :response => response.message, :error_code => response.params["error_codes"])
    end
  end
  ################################### 

  ###################################
  # ORDER OUTCOME METHODS
  ###################################
  # Renders the successful order page, however redirected if the order payment status is not Pending or completed.
  #
  def success
    @order = Order.includes(:ship_address).find(params[:order_id])
    redirect_to root_url unless @order.transactions.last.pending? || @order.transactions.last.completed?
  end

  # Renders the failed order page, however redirected if the order payment stautus it not Failed
  #
  def failure
    @order = Order.includes(:transactions).find(params[:order_id])
    # redirect_to root_url unless @order.transactions.last.failed?
  end

  # When an order has failed, the user has an option to retry the order
  # Although if it has a PayPal error code of 10412 or 10415, create a new order and redirect to review
  # 
  def retry
    @order = Order.includes(:transactions).find(params[:order_id])
    @error_code = @order.transactions.last.error_code
    if @error_code == 10412 || @error_code == 10415
      @order.update_column(:cart_id, nil) 
      redirect_to new_order_path
    else
      redirect_to order_build_url(order_id: @order.id, id: 'review')
    end
  end

  # When an order has failed, the user has an option to discard order
  # However it's details are retained in the database.
  #
  def purge
    @order.update_column(:cart_id, nil)
    flash_message :success, "Your order has been cancelled."
    redirect_to root_url
  end
  ###################################

  ###################################
  # ORDER ESTIMATE SHIPPING
  ###################################
  def estimate
    respond_to do |format|
      if @order.update(params[:order])
        format.js { render partial: 'orders/shippings/estimate/success', format: [:js] }
      else
        format.json { render json: { errors: @order.errors.to_json(root: true) }, status: 422 }
      end
    end
  end

  # Destroys the estimated shipping item from the cart by setting all the session stores values to nil
  #
  def purge_estimate
    @order.update_column(:shipping_id, nil)
    render :partial => 'orders/shippings/estimate/success', :format => [:js]
  end
  ###################################

  ###################################
  # ORDER PRIVATE METHODS
  ###################################
  private

  # Before filter method to check if the order has an associated transaction record with a payment_status of completed
  # Or if the the current_cart is empty, and if so redirect to the homepage.
  #
  def accessible_order
    @order = Order.find(params[:order_id])
    if @order.completed? || current_cart.cart_items.empty?
      flash_message :error, "You do not have permission to amend this order."
      redirect_to root_url
    end
  end

  # Before filter method to validate whether the user is allowed to access a specific step in the order process
  # If not they are redirected to the required step before proceeding further
  #
  def check_order_status
    binding.pry
    @order = Order.find(params[:order_id])
    route = (steps.last(3).include?(params[:id].to_sym) && @order.bill_address.first_name.nil?) ? 'billing' 
            : (steps.last(2).include?(params[:id].to_sym) && @order.ship_address.first_name.nil? || @order.shipping_id.nil?) ? 'shipping' 
            : steps.last(1).include?(params[:id].to_sym) && (params[:token].nil? || params[:PayerID].nil?) ? 'payment' 
            : nil
    redirect_to order_build_url(order_id: @order.id, id: route) unless route.nil?
  end
  ###################################
end