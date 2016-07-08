class SkusController < ApplicationController
    skip_before_action :authenticate_user!
    
    def update
        set_product
        set_sku
        set_accessory
        set_accessory_price
        render json: { 
            price: Store::Price.new(price: (@sku.price + @accessory_price)).markup, 
            html: render_to_string(partial: theme_presenter.page_template_path('products/actions'), locals: { product: @product, sku: @sku }, format: [:html]) 
        }, status: 200
    end

    private

    def set_product
        @product ||= Product.includes(:skus).find(params[:product_id])
    end

    def set_sku
        @sku ||=  @product.active_skus.find(params[:id])
    end

    def set_accessory
        @accessory ||= Accessory.find_by_id(params[:accessory_id])
    end

    def set_accessory_price
        @accessory_price = @accessory.nil? ? 0 : @accessory.price
    end
end