class ShippingsController < ApplicationController

    skip_before_filter :authenticate_user!
    
    # Update shipping results
    #
    # When selecting a shipping country in the order process, the shipping results are updated automatically
    def update
        @tiers = Shipatron4000::tier(current_cart)
        @shippings = Shipping.joins(:tiereds, :countries).where(tiereds: { :tier_id => @tiers }, countries: { :name => params[:country_id] }).order('price ASC').all
        render :partial => "orders/shippings/update"
    end
end