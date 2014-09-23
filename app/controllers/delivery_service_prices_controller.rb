class DeliveryServicePricesController < ApplicationController

    skip_before_action :authenticate_user!
    
    # Update delivery service price results
    # When selecting a delivery country in the cart, the delivery service price results are updated automatically
    # 
    def update
        @delivery_service_prices = DeliveryServicePrice.find_collection(current_cart, params[:country_id])
        render partial: "carts/delivery_service_prices/fields", :locals => { delivery_service_prices: @delivery_service_prices, estimate_delivery_id: current_cart.estimate_delivery_id }
    end
end