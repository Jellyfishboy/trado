require 'payatron_4000'

class OrdersController < ApplicationController
    skip_before_action :authenticate_user!
    include CartBuilder

    def confirm
      set_eager_loading_order
      set_address_variables
      validate_confirm_render
    end

    def complete
      set_order
      # redirect_url = Store::PayProvider.new(order: @order, provider: @order.payment_type, session: session, ip_address: request.remote_ip).complete
      charge = Stripe::Charge.create(
        amount: Store::Price.new(price: @order.gross_amount, tax_type: 'net').singularize,
        currency: Store.settings.currency_code,
        customer: @order.stripe_customer_token,
        description: "#{@order.id} | #{@order.billing_address.full_name}",
        metadata:
        {
          line_items: @order.order_items.map{|item| [item.sku.product.name, sku.full_sku]}
        }
      )
      redirect_to redirect_url
    end

    def success
      set_order
      if @order.latest_transaction.pending? || @order.latest_transaction.completed?
        render theme_presenter.page_template_path('orders/success'), layout: theme_presenter.layout_template_path
      else
        redirect_to root_url 
      end
    end

    def failed
      set_order
      if @order.latest_transaction.failed?
        render theme_presenter.page_template_path('orders/failed'), layout: theme_presenter.layout_template_path
      else
        redirect_to root_url
      end
    end

    def retry
      set_order
      if Modulatron4000.paypal? && TradoPaypalModule::Paypaler.fatal_error_code?(@order.last_error_code)
        Payatron4000.decommission_order(@order)
      end
      redirect_to mycart_carts_url
    end

    def destroy
      set_order
      Payatron4000.decommission_order(@order)
      flash_message :success, "Your order has been cancelled."
      redirect_to root_url
    end

    private

    # def set_order
    #   @order ||= Order.active.find(params[:id])
    # end

    def set_eager_loading_order
      @order ||= current_cart.order.includes(:delivery_address, :billing_address)
    end

    def set_address_variables
      @delivery_address = @order.delivery_address
      @billing_address = @order.billing_address
    end

    def validate_confirm_render
      if Payatron4000.order_pay_provider_valid?(@order, params)
          TradoPaypalModule::Paypaler.assign_paypal_token(params[:token], params[:PayerID], @order) if @order.paypal?
          render theme_presenter.page_template_path('orders/confirm'), layout: theme_presenter.layout_template_path
      else
        flash_message :error, 'An error ocurred when trying to complete your order. Please try again.'
        redirect_to checkout_carts_url
      end
    end
end