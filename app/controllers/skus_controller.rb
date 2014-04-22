class SkusController < ApplicationController

    # Update SKU
    #
    # Modal trigger for displaying a form to update the SKU selection on the product page
    def update
        render :partial => 'products/skus/update', :format => [:js]
    end

end