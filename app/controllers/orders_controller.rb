class OrdersController < ApplicationController

    skip_before_action :authenticate_user!
    before_action :set_order, only: [:destroy, :retry, :complete]

    def confirm
      @order = Order.includes(:delivery_address, :billing_address).find(params[:id])
      @delivery_address = @order.delivery_address
      @billing_address = @order.billing_address
      redirect_to checkout_carts_url if params[:token].nil? || params[:PayerID].nil?
      Payatron4000::Paypal.assign_paypal_token(params[:token], params[:PayerID], @order) if params[:token] && params[:PayerID]

      render theme_presenter.page_template_path('orders/confirm'), layout: theme_presenter.layout_template_path
    end

    def complete
      @order.transfer(current_cart)
      redirect_to Payatron4000::Paypal.complete(@order, session)
    end

    def success
      @order = Order.includes(:delivery_address).find(params[:id])
      redirect_to root_url unless @order.transactions.last.pending? || @order.transactions.last.completed?
      render theme_presenter.page_template_path('orders/success'), layout: theme_presenter.layout_template_path
    end

    def failed
      @order = Order.includes(:transactions).find(params[:id])
      redirect_to root_url unless @order.transactions.last.failed?
      render theme_presenter.page_template_path('orders/failed'), layout: theme_presenter.layout_template_path
    end

    def retry
      @error_code = @order.transactions.last.error_code
      @order.update_column(:cart_id, session[:cart_id]) unless Payatron4000::fatal_error_code?(@error_code)
      redirect_to mycart_carts_url
    end

    def destroy
      @order.update_column(:cart_id, nil)
      flash_message :success, "Your order has been cancelled."
      redirect_to root_url
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end
end