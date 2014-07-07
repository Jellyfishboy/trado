class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  skip_before_filter :authenticate_user!

  before_filter :check_order_status, only: :show

  before_filter :accessible_order, except: [:success, :failure]

  steps :review, :billing, :shipping, :payment, :confirm

  # Displays the front-end content of each step, with specific methods throughout providing the relevant data
  # Steps include, in this order: review, billing, shipping, payment then confimration
  #
  def show
    @cart = current_cart
    # Sets current state of the order
    if step == steps.last
      @order.update_column(:status, 'active')
    else
      @order.update_column(:status, step.to_s)
    end
    case step
    when :billing
      @billing_address = @order.bill_address
    end
    case step
    when :shipping
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

  # When advancing to the next step in the order process, the update method is called
  # Any bespoke business logic in each step is then triggered, for example: updating the address and the order status attribute value
  #
  def update 
    @cart = current_cart
    case step 
    when :billing

      @billing_address = @order.bill_address
      # Update billing attributes
      if @billing_address.update_attributes(params[:address])
        # Update order attributes in the form
        unless @order.update_attributes(params[:order])
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
      if @shipping_address.update_attributes(params[:address])
        # Update order attributes in the form
        unless @order.update_attributes(params[:order])
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
      if @order.update_attributes(params[:order])
        @order.transfer(current_cart)
        unless session[:payment_type].nil?
          url = Payatron4000::Generic.complete(@order, session[:payment_type], session)
        else
          url = Payatron4000::Paypal.complete(@order, session)
        end
        redirect_to url
      else
        render_wizard @order
      end
    end
   end

  ## PAYMENT TYPES ##

  # Prepares the order data and redirects to the PayPal login page to review the order
  # Set the payment_type session value to nil in order to prevent the wrong complete method being fired in the purchase method below
  # Bespoke PayPal method
  #
  def express
    session[:payment_type] = nil
    response = EXPRESS_GATEWAY.setup_purchase(Store::Price.new(@order.gross_amount, 'net').singularize, 
                                              Payatron4000::Paypal.express_setup_options( @order, 
                                                                                          steps, 
                                                                                          current_cart,
                                                                                          request.remote_ip, 
                                                                                          order_build_url(:order_id => @order.id, :id => steps.last), 
                                                                                          order_build_url(:order_id => @order.id, :id => 'payment')
                                              )
    )
    # if response.success?
      redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    # else
    #   begin
    #     Payatron4000::Paypal.failed(response, @order)
    #   rescue Exception => e
    #     Rollbar.report_exception(e)
    #   end
    #   redirect_to failure_order_build_url( :order_id => @order.id, :id => 'confirm', :response => response.message, :error_code => response.params["error_codes"])
    # end
  end

  # Payment method for a bank transfer, which sets the payment_type session value to Bank tranfer
  # Redirect to last step in the order process
  #
  def bank_transfer
    session[:payment_type] = 'Bank transfer' 
    redirect_to order_build_url(:order_id => @order.id, :id => steps.last)
  end

  # Payment method for a cheque, which sets the payment_type session value to Cheque
  # Redirect to last step in the order process
  #
  def cheque
    session[:payment_type] = 'Cheque'
    redirect_to order_build_url(:order_id => @order.id, :id => steps.last)
  end

  ## END OF PAYMENT TYPES ##  

  # Renders the successful order page, however redirected if the order payment status is not Pending or completed.
  #
  def success
    @order = Order.find(params[:order_id])
    redirect_to root_url unless @order.transactions.last.payment_status == 'Pending' || @order.transactions.last.payment_status == 'Completed'
  end

  # Renders the failed order page, however redirected if the order payment stautus it not Failed
  #
  def failure
    @order = Order.find(params[:order_id])
    Rollbar.report_message("Order ##{@order.id}. Paypal #{params[:error_code]} error: #{params[:response]}", "info", :order => @order) unless params[:response].nil? || params[:error_code].nil?
    redirect_to root_url unless @order.transactions.last.payment_status == 'Failed' 
  end

  # When an order has failed, the user has an option to discard order. However it's details are retained in the database.
  #
  def purge
    @order.update_column(:cart_id, nil)
    flash_message :success, "Your order has been cancelled."
    redirect_to root_url
  end

  def estimate
    respond_to do |format|
      if @order.update_attributes(params[:order])
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
    @order = Order.find(params[:order_id])
    route = (steps.last(3).include?(params[:id].to_sym) && @order.bill_address.first_name.nil?) ? 'billing' 
            : (steps.last(2).include?(params[:id].to_sym) && @order.ship_address.first_name.nil?) ? 'shipping' 
            : steps.last(1).include?(params[:id].to_sym) && ((params[:token].nil? || params[:PayerID].nil?) || session[:payment_type].nil?) ? 'payment' 
            : nil
    redirect_to order_build_url(order_id: @order.id, id: route) unless route.nil?
  end

end