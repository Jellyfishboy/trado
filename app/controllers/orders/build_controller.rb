class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  skip_before_filter :authenticate_user!

  before_filter :accessible_order, :only => [:show, :update, :express, :purchase]

  steps :review, :billing, :shipping, :payment, :confirm

  def show
    @cart = current_cart
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
      @order.calculate(current_cart, Store::tax_rate)
    end
    case step
    when :confirm
      if defined?(params[:token])
        Payatron4000::Paypal.assign_paypal_token(params[:token], params[:PayerID], session, @order)
      end
    end
    render_wizard
  end

  def update 
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

  # Prepares the order data and redirects to the PayPal login page to review the order
  #
  def express
    response = EXPRESS_GATEWAY.setup_purchase(Payatron4000::price_in_pennies(@order.gross_amount), 
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


  def purchase 
    response = EXPRESS_GATEWAY.purchase(Payatron4000::price_in_pennies(@order.gross_amount), 
                                        Payatron4000::Paypal.express_purchase_options(@order)
    )
    @order.add_cart_items_from_cart(current_cart) if @order.transactions.blank?
    if response.success?
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      begin 
        Payatron4000::Paypal.successful(response, @order)
      rescue Exception => e
        Rollbar.report_exception(e)
      end
      if response.params['PaymentInfo']['PaymentStatus'] == "Pending"
        OrderMailer.pending(@order).deliver
      else
        OrderMailer.received(@order).deliver
      end
      redirect_to success_order_build_url(:order_id => @order.id, 
                                          :id => steps.last
      )
    else
      begin
        Payatron4000::Paypal.failed(response, @order)
      rescue Exception => e
        Rollbar.report_exception(e)
      end
      redirect_to failure_order_build_url(:order_id => @order.id, 
                                          :id => steps.last, 
                                          :response => response.message, 
                                          :error_code => response.params["error_codes"]
      )
    end
  end

  # Renders the successful order page, however redirected if the order payment status is not Pending or completed
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
    unless @order.transactions
      @order.destroy
      flash[:success] = "Your order has been deleted."
      redirect_to root_url
    else
      flash[:error] = "Cannot delete a completed order."
      redirect_to root_url
    end
  end

  private

  # Before filter method to check if the order has an associated transaction record with a payment_status of completed
  # Or if the the current_cart is empty, and if so redirect to the homepage.
  #
  def accessible_order
    @order = Order.find(params[:order_id])
    @orders = @order.transactions.where(:payment_status => 'Completed').blank? ? false : true
    if @orders || current_cart.cart_items.empty?
      flash[:error] = "You do not have permission to amend this order."
      redirect_to root_url
    end
  end

end