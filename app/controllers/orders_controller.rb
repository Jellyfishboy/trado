class OrdersController < ApplicationController
    include ModulesHelper
    skip_before_action :authenticate_user!

    def confirm
      set_eager_loading_order
      set_address_variables
      validate_confirm_render
    end

    def complete
      set_order
      redirect_to Store::PayProvider.new(order: @order, provider: @order.payment_type, session: session).complete
    end

    def success
      @order = Order.active.includes(:delivery_address).find(params[:id])
      if @order.latest_transaction.pending? || @order.latest_transaction.completed?
        render theme_presenter.page_template_path('orders/success'), layout: theme_presenter.layout_template_path
      else
        redirect_to root_url 
      end
    end

    def failed
      @order = Order.active.includes(:transactions).find(params[:id])
      if @order.latest_transaction.failed?
        render theme_presenter.page_template_path('orders/failed'), layout: theme_presenter.layout_template_path
      else
        redirect_to root_url
      end
    end

    def retry
      set_order
      @error_code = @order.latest_transaction.error_code
      if paypal_active? && !TradoPaypalModule::Paypaler.fatal_error_code?(@error_code)
        @order.update_column(:cart_id, current_cart.id)
      end
      redirect_to mycart_carts_url
    end

    def destroy
      set_order
      Ordatron4000.decommission_order(@order)
      flash_message :success, "Your order has been cancelled."
      redirect_to root_url
    end

    private

    def set_order
      @order ||= Order.active.find(params[:id])
    end

    def set_eager_loading_order
      @order ||= Order.active.includes(:delivery_address, :billing_address).find(params[:id])
    end

    def set_address_variables
      @delivery_address = @order.delivery_address
      @billing_address = @order.billing_address
    end

    def validate_confirm_render
      if @order.payment_type.nil?
        redirect_to checkout_carts_url
      elsif @order.paypal?
        if paypal_active? && params[:token].present? && params[:PayerID].present?
          TradoPaypalModule::Paypaler.assign_paypal_token(params[:token], params[:PayerID], @order)
          render theme_presenter.page_template_path('orders/confirm'), layout: theme_presenter.layout_template_path
        else
          flash_message :error, 'An error ocurred when trying to complete your order. Please try again.'
          redirect_to checkout_carts_url
        end
      end
    end
end