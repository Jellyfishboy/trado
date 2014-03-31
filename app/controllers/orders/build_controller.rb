class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  skip_before_filter :authenticate_user!

  steps :review, :billing, :shipping, :payment, :confirm

  def show
    @cart = current_cart
    @order = Order.find(params[:order_id])
    if @order.transaction || current_cart.cart_items.empty?
      flash[:error] = "You do not have permission to amend this order."
      redirect_to root_url
    else
      case step
      when :billing
        # If billing address exists, load the current record and populate the fields
        if @order.bill_address_id
          @billing_address = Address.find(@order.bill_address_id)
        else
          # Else create a new record
          @billing_address = Address.new
        end
      end
      case step
      when :shipping
        if @order.ship_address_id
          @shipping_address = Address.find(@order.ship_address_id)
        else
          # Else create a new record
          @shipping_address = Address.new
        end
        @calculated_tier = @order.calculate_shipping_tier(current_cart)
      end
      case step 
      when :payment
        @order.calculate_order(current_cart, session, Store::tax_rate)
      end
      case step
      when :confirm
        if defined?(params[:token])
          Payatron4000::Paypal.assign_paypal_token(params[:token], params[:PayerID], session, @order)
        end
      end
      render_wizard
    end
  end

  def update 
    @order = Order.find(params[:order_id])
    # Sets current state of the order
    if step == steps.last
      @order.update_column(:status, 'active')
    else
      @order.update_column(:status, step.to_s)
    end
    case step 
    when :billing
      if @order.bill_address_id
        @billing_address = Address.find(@order.bill_address_id)
      else
        @billing_address = Address.new(:addressable_id => @order.id, :addressable_type => 'Order')
      end
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
      @calculated_tier = @order.calculate_shipping_tier(current_cart)
      if @order.ship_address_id
        @shipping_address = Address.find(@order.ship_address_id)
      else
        @shipping_address = Address.new(:addressable_id => @order.id, :addressable_type => 'Order')
      end
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

  def express
    @order = Order.find(params[:order_id])
    if @order.transaction || current_cart.cart_items.empty?
      flash[:error] = "You do not have permission to amend this order."
      redirect_to root_url
    else
      response = EXPRESS_GATEWAY.setup_purchase(Payatron4000.price_in_pennies(session[:total]), Payatron4000::Paypal.express_setup_options(@order, steps, current_cart, session, request.remote_ip, order_build_url(:order_id => @order.id, :id => steps.last), order_build_url(:order_id => @order.id, :id => 'payment')))
      redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    end
  end

  def purchase 
    @order = Order.find(params[:order_id])
    if @order.transaction || current_cart.cart_items.empty?
      flash[:error] = "You do not have permission to amend this order."
      redirect_to root_url
    else
      response = EXPRESS_GATEWAY.purchase(Payatron4000.price_in_pennies(session[:total]), Payatron4000::Paypal.express_purchase_options(@order, session))
      binding.pry
      if response.success
        @order.add_cart_items_from_cart(current_cart)
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        begin 
          Payatron4000::Paypal.successful(response, @order)
          @order.successful_order(response)
        rescue Exception => e
            Rollbar.report_exception(e)
        end
        if response.params['PaymentInfo']['PaymentStatus'] == "Pending"
          Notifier.pending_order(@order).deliver
        else
          Notifier.order_received(@order).deliver
        end
        redirect_to success_order_build_url(:order_id => @order.id, :id => steps.last, :transaction_id => response.params['PaymentInfo']['TransactionID'])
      else
        begin
          Payatron4000::Paypal.failed(response, @order)
        rescue Exception => e
            Rollbar.report_exception(e)
        end
        redirect_to failure_order_build_url(:order_id => @order.id, :id => steps.last, :response => response.message, :error_code => response.params["error_codes"], :correlation_id => response.params['correlation_id'])
      end
    end
  end

  def success
    @order = Order.find(params[:order_id])

    respond_to do |format|
      unless params[:transaction_id].blank?
        format.html
      else
        format.html { redirect_to root_url }
      end
    end
  end

  def failure
    @order = Order.find(params[:order_id])

    respond_to do |format|
      unless params[:correlation_id].blank?
        format.html
      else
        format.html { redirect_to root_url }
      end
    end
  end

  def purge
    @order = Order.find(params[:order_id])
    unless @order.transaction
      @order.destroy
      flash[:success] = "Your order has been deleted."
      redirect_to root_url
    else
      flash[:error] = "Cannot delete a completed order."
      redirect_to root_url
    end
  end

end