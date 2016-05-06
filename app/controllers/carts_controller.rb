class CartsController < ApplicationController
    include CartBuilder
    skip_before_action :authenticate_user!

    def mycart
        set_cart_totals
        set_cart_session
        render theme_presenter.page_template_path('carts/mycart'), layout: theme_presenter.layout_template_path
    end

    def checkout
        set_order
        build_addresses
        set_cart_totals
        set_cart_session
        set_delivery_services
        render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
    end


    def update
        current_cart.update(params[:cart])
        render json: { delivery: current_cart.delivery }, status: 200
        # format.js { render partial: theme_presenter.page_template_path('carts/delivery_service_prices/estimate/success'), format: [:js] }
    end

    def reset
        current_cart.update(delivery_id: nil, country: nil)
        render json: { }, status: 200
        # render partial: theme_presenter.page_template_path('carts/delivery_service_prices/estimate/success'), format: [:js]
    end

    private

    def build_addresses
        @order.build_delivery_address
        @order.build_billing_address
    end
end