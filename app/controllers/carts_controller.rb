class CartsController < ApplicationController

    skip_before_action :authenticate_user!
    before_action :set_cart_details, only: [:checkout, :confirm]

    def mycart
        render theme_presenter.page_template_path('carts/mycart'), layout: theme_presenter.layout_template_path
    end

    def checkout
        if current_cart.order.nil?
            @delivery_id = current_cart.estimate_delivery_id
            @delivery_address = @order.build_delivery_address
            @billing_address = @order.build_billing_address
        else
            @delivery_id = @order.delivery_id
        end
        render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
    end

    def confirm
        @order.attributes = params[:order]
        session[:payment_type] = params[:payment_type]
        if @order.save
            @order.calculate(current_cart, Store::tax_rate)
            redirect_to Store::PayProvider.new(cart: current_cart, order: @order, provider: session[:payment_type], ip_address: request.remote_ip).build
        else
            render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
        end
    rescue ActiveMerchant::ConnectionError
        flash_message :error, 'An error ocurred when trying to complete your order. Please try again.'  
        Rails.logger.error "#{session[:payment_type]}: This API is temporarily unavailable."
        redirect_to checkout_carts_url
    end

    def estimate
        @cart = current_cart
        respond_to do |format|
          if @cart.update(params[:cart])
            format.js { render partial: theme_presenter.page_template_path('carts/delivery_service_prices/estimate/success'), format: [:js] }
          else
            format.json { render json: { errors: @cart.errors.to_json(root: true) }, status: 422 }
          end
        end
    end

    def purge_estimate
        @cart = current_cart
        @cart.estimate_delivery_id = nil
        @cart.estimate_country_name = nil
        @cart.save(validate: false)
        render partial: theme_presenter.page_template_path('carts/delivery_service_prices/estimate/success'), format: [:js]
    end

    private

    def set_cart_details
        @order = current_cart.order.nil? ? Order.new : current_cart.order
        @cart_total = current_cart.calculate(Store::tax_rate)
        @country = @order.delivery_address.nil? ? current_cart.estimate_country_name : @order.delivery_address.country
        @delivery_service_prices = DeliveryServicePrice.find_collection(current_cart, @country) unless current_cart.estimate_delivery_id.nil? && @order.delivery_address.nil?
    end
end