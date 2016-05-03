class Carts::PayPalController < ApplicationController
    include CartBuilder

    def confirm
        set_order
        set_cart_session
        set_delivery_services
        @order.attributes = params[:order]
        session[:payment_type] = params[:payment_type]
        if @order.save
            @order.calculate(current_cart, Store.tax_rate)
            generate_payment_url
            if @redirect_url.nil?
                flash_message :error, 'An error ocurred when trying to complete your order. Please try again.'
                redirect_to checkout_carts_url
            else
                redirect_to @redirect_url
            end
        else
            render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
        end
    rescue ActiveMerchant::ConnectionError
        flash_message :error, 'An error ocurred when trying to complete your order. Please try again.'  
        Rails.logger.error "#{session[:payment_type]}: This payment provider API is temporarily unavailable."
        redirect_to checkout_carts_url
    end

    private

    def generate_payment_url
        @redirect_url = Store::PayProvider.new(cart: current_cart, order: @order, provider: session[:payment_type], ip_address: request.remote_ip).build
    end
end