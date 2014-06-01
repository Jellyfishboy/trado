class ShippingsController < ApplicationController

    skip_before_filter :authenticate_user!
    
    # Update shipping results
    #
    # When selecting a shipping country in the order process, the shipping results are updated automatically
    def update
        @tiers = Shipatron4000::tier(current_cart)
        @shippings = @tiers.map{ |t| t.shippings.map{ |s| s } }.flatten
        @new_shippings = Shipping.where(:id => @shippings.map(&:id)).joins(:countries).where('countries.name = ?', params[:country_id]).order('price ASC').all
        render :partial => "orders/shippings/update"
    end
end