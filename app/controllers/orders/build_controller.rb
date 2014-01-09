class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  steps :review, :billing, :shipping, :payment, :confirm

  def show
    @cart = current_cart
    @order = Order.find(params[:order_id])
    if @order.transaction
      redirect_to root_url, flash[:notice] => "You do not have permission to amend this order."
    else
      case step
      when :shipping
        @calculated_tier = @order.calculate_shipping_tier(current_cart)
      end
      case step 
      when :payment
        @order.calculate_order(current_cart, session)
      end
      case step
      when :confirm
        if defined?(params[:token])
          @order.assign_paypal_token(params[:token], params[:PayerID], session)
        end
      end
      render_wizard
    end
  end

  def update 
    @order = Order.find(params[:order_id])
    params[:order][:status] = step.to_s # sets current state of form for the correct validation to trigger, i.e. the steps labeled above
    params[:order][:status] = 'active' if step == steps.last # sets the status as active on the last step so all validation is triggered
    @order.update_attributes(params[:order])
    case step
    when :shipping
      @calculated_tier = @order.calculate_shipping_tier(current_cart)
      @order.update_shipping_information
    end
    render_wizard @order
  end

  def express
    @order = Order.find(params[:order_id])
    if @order.transaction
      redirect_to root_url, flash[:notice] => "You do not have permission to amend this order."
    else
      response = EXPRESS_GATEWAY.setup_purchase(price_in_pennies(session[:total]), express_setup_options(@order))
      redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
    end
  end

  def purchase 
    @order = Order.find(params[:order_id])
    if @order.transaction
      redirect_to root_url, flash[:notice] => "You do not have permission to amend this order."
    else
      response = EXPRESS_GATEWAY.purchase(price_in_pennies(session[:total]), express_purchase_options(@order))
      if response.success?
        @order.add_line_items_from_cart(current_cart)
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        # Notifier.order_received(@order).deliver
        @order.finish_order(response)
        redirect_to success_order_build_url(:order_id => @order.id, :id => steps.last, :transaction_id => response.params['PaymentInfo']['TransactionID'])
      else
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
      redirect_to root_url, notice: 'Your order has been deleted.'
    else
      redirect_to root_url, flash[:notice] => 'Cannot delete a completed order.'
    end
  end

private

  def express_purchase_options(order)
    {
      :subtotal          => price_in_pennies(session[:sub_total]),
      :shipping          => price_in_pennies(order.shipping_cost),
      :tax               => price_in_pennies(session[:tax]),
      :handling          => 0,
      :token             => order.express_token,
      :payer_id          => order.express_payer_id,
      :currency          => 'GBP'
    }
  end

  def express_setup_options(order)
    {
      :subtotal          => price_in_pennies(session[:sub_total]),
      :shipping          => price_in_pennies(order.shipping_cost),
      :tax               => price_in_pennies(session[:tax]),
      :handling          => 0,
      :order_id          => order.id,
      :items             => express_items,
      :ip                => request.remote_ip,
      :return_url        => order_build_url(:order_id => order.id, :id => steps.last),
      :cancel_return_url => order_build_url(:order_id => order.id, :id => 'payment'),
      :currency          => 'GBP',
    }
  end

  def price_in_pennies(price)
    (price*100).round
  end

  def express_items
    current_cart.line_items.collect do |item|
      {
        :name => item.product.name,
        :description => "#{item.attribute_value}#{item.attribute_measurement unless item.attribute_measurement.nil? }",
        :amount => price_in_pennies(item.price), 
        :quantity => item.quantity 
      }
    end
  end

end