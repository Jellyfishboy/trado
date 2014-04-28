class ShippingsController < ApplicationController

    skip_before_filter :authenticate_user!
    
    # Update shipping results
    #
    # When selecting a shipping country in the order process, the shipping results are updated automatically
    def update
        @tier = Tier.find(params[:tier_id])
        @new_shippings = @tier.shippings.joins(:countries).where('countries.name = ?', params[:country_id]).all
        render :partial => "orders/shippings/update"
    end
end