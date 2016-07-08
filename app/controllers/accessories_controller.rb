class AccessoriesController < ApplicationController
    skip_before_action :authenticate_user!
    
    def update 
        set_product
        set_accessory
        set_accessory_price
        set_sku
        render json: { price: Store::Price.new(price: (@sku.price + @accessory_price)).markup, }, status: 200
    end

    private

    def set_product
        @product ||= Product.includes(:skus).find(params[:product_id])
    end

    def set_sku
        @sku ||=  @product.active_skus.find(params[:sku_id])
    end

    def set_accessory
        @accessory ||= Accessory.find_by_id(params[:accessory_id])
    end

    def set_accessory_price
        @accessory_price = @accessory.nil? ? 0 : @accessory.price
    end
end