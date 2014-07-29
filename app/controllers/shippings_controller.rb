class ShippingsController < ApplicationController

    skip_before_action :authenticate_user!
    
    # Update shipping results
    #
    # When selecting a shipping country in the order process, the shipping results are updated automatically
    def update
        @shippings = Shipping.find_collection(current_cart, params[:country_id])
        render partial: "orders/shippings/fields", :locals => { shippings: @shippings, shipping_id: current_cart.order.shipping_id }
    end
end