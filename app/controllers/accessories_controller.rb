class AccessoriesController < ApplicationController

    skip_before_action :authenticate_user!
    
    # Update accessory
    #
    # Update the price of a product when selecting an accessory
    def update 
        render :partial => 'products/accessories/update', :format => [:js]
    end

end