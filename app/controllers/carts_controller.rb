class CartsController < ApplicationController
    skip_before_action :authenticate_user!

    def mycart
        render theme_presenter.page_template_path('carts/mycart'), layout: theme_presenter.layout_template_path
    end

    def checkout
        set_order
        set_cart_session
        set_delivery_services
        render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
    end

    def confirm
        set_order
        set_cart_session
        @order.attributes = params[:order]
        session[:payment_type] = params[:payment_type]
        if @order.save
            @order.calculate(current_cart, Store.tax_rate)
            generate_payment_url
            if @url.nil?
                flash_message :error, 'An error ocurred when trying to complete your order. Please try again.'
                redirect_to checkout_carts_url
            else
                redirect_to @url
            end
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
        @cart.delivery_id = nil
        @cart.country = nil
        @cart.save(validate: false)
        render partial: theme_presenter.page_template_path('carts/delivery_service_prices/estimate/success'), format: [:js]
    end

    private

    def set_order
        @order ||= current_cart.order.nil? ? Order.new : current_cart.order
    end

    def set_delivery_services
        @delivery_services = @cart_session[:country].nil? ? nil : DeliveryServicePrice.find_collection(current_cart.delivery_service_ids, @cart_session[:country])
    end

    def set_cart_session
        @cart_session = {
            total: current_cart.calculate(Store.tax_rate),
            country: @order.delivery_address.nil? ? current_cart.country : @order.delivery_address.country,
            delivery_id: @order.new_record? ? current_cart.delivery_id : @order.delivery_id
        }
    end

    def generate_payment_url
        @url = Store::PayProvider.new(cart: current_cart, order: @order, provider: session[:payment_type], ip_address: request.remote_ip).build
    end
end