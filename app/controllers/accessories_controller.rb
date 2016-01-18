class AccessoriesController < ApplicationController
    skip_before_action :authenticate_user!
    
    # Update accessory
    #
    # Update the price of a product when selecting an accessory
    def update 
        render partial: theme_presenter.page_template_path('products/accessories/update'), format: [:js]
    end

end