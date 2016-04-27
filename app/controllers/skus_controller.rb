class SkusController < ApplicationController
    skip_before_action :authenticate_user!
    
    def update
        set_product
        set_sku
        set_accessory
        set_accessory_price
        set_html_action
        render json: { 
            price: Store::Price.new(price: (@sku.price + @accessory_price)).markup, 
            action: @action 
        }, status: 200
    end

    def notify
        @sku = Sku.find(params[:id])
        @notification = Notification.new
        render partial: theme_presenter.page_template_path('products/skus/notify/new'), format: [:js]
    end

    private

    def set_product
        @product ||= Product.includes(:skus).find(params[:product_id])
    end

    def set_sku
        @sku ||=  @product.skus.active.find(params[:id])
    end

    def set_accessory
        @accessory ||= Accessory.find_by_id(params[:accessory_id])
    end

    def set_accessory_price
        @accessory_price = @accessory.nil? ? 0 : @accessory.price
    end
    
    def set_html_action
        @action = @sku.in_stock? ? render_to_string(partial: theme_presenter.page_template_path('products/addtocart'), locals: { product: @product }) : render_to_string(partial: theme_presenter.page_template_path('products/notifyme'), locals: { product: @product, sku: @sku })
    end
end