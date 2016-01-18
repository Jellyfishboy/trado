class DeliveryServicePricesController < ApplicationController
    skip_before_action :authenticate_user!
    
    # Update delivery service price results
    # When selecting a delivery country in the cart, the delivery service price results are updated automatically
    # 
    def update
        @delivery_service_prices = DeliveryServicePrice.find_collection(session[:delivery_service_prices], params[:country_id])
        @field_target = params[:object_type] == 'cart' ? 'cart[estimate_delivery_id]' : 'order[delivery_id]'
        render partial: theme_presenter.page_template_path("carts/delivery_service_prices/fields"), format: [:html], locals: { delivery_service_prices: @delivery_service_prices, delivery_id: current_cart.estimate_delivery_id, field_target: @field_target }
    end
end