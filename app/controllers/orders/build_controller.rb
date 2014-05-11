class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  skip_before_filter :authenticate_user!

  before_filter :accessible_order, :only => [:show, :update, :express, :cheque, :bank_transfer, :purchase]

  steps :review, :billing, :shipping, :payment, :confirm

  # Displays the front-end content of each step, with specific methods throughout providing the relevant data
  # Steps include, in this order: review, billing, shipping, payment then confimration
  #
  def show
    @cart = current_cart
    case step
    when :billing
      @billing_address = Payatron4000::select_address(@order.id, @order.bill_address_id)
    end
    case step
    when :shipping
      @shipping_address = Payatron4000::select_address(@order.id, @order.ship_address_id)
      @calculated_tier = @order.tier(current_cart)
    end
    case step 
    when :payment
      @order.calculate(current_cart, Store::tax_rate)
    end
    case step
    when :confirm
      Payatron4000::Paypal.assign_paypal_token(params[:token], params[:PayerID], session, @order) if params[:token]
    end
    render_wizard
  end

  # When advancing to the next step in the order process, the update method is called
  # Any bespoke business logic in each step is then triggered, for example: updating the address and the order status attribute value
  #
  def update 
    # Sets current state of the order
    if step == steps.last
      @order.update_column(:status, 'active')
    else
      @order.update_column(:status, step.to_s)
    end
    case step 
    when :billing

      @billing_address = Payatron4000::select_address(@order.id, @order.bill_address_id)
      # Update billing attributes
      if @billing_address.update_attributes(params[:address])
        # Add billing ID to order record
        @order.update_column(:bill_address_id, @billing_address.id) unless @order.bill_address_id
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
      @calculated_tier = @order.tier(current_cart)
      @shipping_address = Payatron4000::select_address(@order.id, @order.ship_address_id)
      # Update billing attributes
      if @shipping_address.update_attributes(params[:address])
        # Add billing ID to order record
        @order.update_column(:ship_address_id, @shipping_address.id) unless @order.ship_address_id
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
  end

  # Prepares the order data and redirects to the PayPal login page to review the order
  # Set the payment_type session value to nil in order to prevent the wrong complete method being fired in the purchase method below
  # Bespoke PayPal method
  #
  def express
    session[:payment_type] = nil
    response = EXPRESS_GATEWAY.setup_purchase(Payatron4000::singularize_price(@order.gross_amount), 
                                              Payatron4000::Paypal.express_setup_options( @order, 
                                                                                          steps, 
                                                                                          current_cart,
                                                                                          request.remote_ip, 
                                                                                          order_build_url(:order_id => @order.id, :id => steps.last), 
                                                                                          order_build_url(:order_id => @order.id, :id => 'payment')
                                              )
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
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

  # Transfers all the cart_items to new order_items (including cart_item_accessories => order_item_accessories)
  # If there is a payment_type value set in the session store, trigger the generic complete method
  # Else trigger the bespoke PayPal complete method
  #
  def purchase 
    binding.pry
    @order.transfer(current_cart) if @order.transactions.blank?
    unless session[:payment_type].nil?
      Payatron4000::Generic.complete(@order, session[:payment_type], session, steps)
    else
      Payatron4000::Paypal.complete(@order, session, steps)
    end
  end

  # Renders the successful order page, however redirected if the order payment status is not Pending or completed.
  #
  def success
    @order = Order.find(params[:order_id])

    respond_to do |format|
      if @order.transactions.last.payment_status == 'Pending' || @order.transactions.last.payment_status == 'Completed'
        format.html
      else
        format.html { redirect_to root_url }
      end
    end
  end

  # Renders the failed order page, however redirected if the order payment stautus it not Failed
  #
  def failure
    @order = Order.find(params[:order_id])

    respond_to do |format|
      if @order.transactions.last.payment_status == 'Failed'
        format.html
      else
        format.html { redirect_to root_url }
      end
    end
  end

  # When an order has failed, the user has an option to delete the order altogether including addresses and order_items
  #
  def purge
    @order = Order.find(params[:order_id])
    if @order.completed?
      flash[:error] = "Cannot delete a completed order."
      redirect_to root_url
    else
      @order.destroy
      flash[:success] = "Your order has been deleted."
      redirect_to root_url
    end
  end

  private

  # Before filter method to check if the order has an associated transaction record with a payment_status of completed
  # Or if the the current_cart is empty, and if so redirect to the homepage.
  #
  def accessible_order
    @order = Order.find(params[:order_id])
    if @order.completed? || current_cart.cart_items.empty?
      flash[:error] = "You do not have permission to amend this order."
      redirect_to root_url
    end
  end

end