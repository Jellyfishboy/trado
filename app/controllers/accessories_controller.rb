class AccessoriesController < ApplicationController

    # Update accessory
    #
    # Modal trigger for displaying a form to update the accessory selection on the product page
    def update 
        render :partial => 'products/accessories/update', :format => [:js]
    end

end