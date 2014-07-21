class SkusController < ApplicationController

    skip_before_action :authenticate_user!
    
    # Update SKU
    #
    # Update the price of a product when selecting a SKU
    def update
        render :partial => 'products/skus/update', :format => [:js]
    end

end