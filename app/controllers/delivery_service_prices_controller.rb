class DeliveryServicePricesController < ApplicationController
    skip_before_action :authenticate_user!
    
    # Update delivery service price results
    # When selecting a delivery country in the cart, the delivery service price results are updated automatically
    # 
    def show
        set_delivery_service_prices
        set_cart
        render json: { table: render_to_string(partial: theme_presenter.page_template_path("carts/delivery_service_prices/table"), format: [:html], locals: { delivery_service_prices: @delivery_service_prices }) }, status: 200
    end

    private

    def set_delivery_service_prices
        @delivery_service_prices = DeliveryServicePrice.find_collection(current_cart.delivery_service_ids, params[:id])
    end

    def set_cart
        @cart ||= current_cart
    end
end