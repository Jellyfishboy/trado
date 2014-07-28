class ShippingsController < ApplicationController

    skip_before_action :authenticate_user!
    
    # Update shipping results
    #
    # When selecting a shipping country in the order process, the shipping results are updated automatically
    def update
        Shipatron4000::shippings(params[:country_id], current_cart)
    end
end