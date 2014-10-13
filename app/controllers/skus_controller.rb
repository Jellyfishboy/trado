class SkusController < ApplicationController

    skip_before_action :authenticate_user!
    
    # Update SKU
    #
    # Update the price of a product when selecting a SKU
    def update
        render partial: theme_presenter.page_template_path('products/skus/update'), format: [:js]
    end

    # Notify me SKU
    #
    # Renders a modal form so a user can be notified when the SKU is back in stock
    def notify
        @sku = Sku.find(params[:id])
        @notification = Notification.new
        render partial: theme_presenter.page_template_path('products/skus/notify/new'), format: [:js]
    end
end