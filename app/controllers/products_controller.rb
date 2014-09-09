class ProductsController < ApplicationController

  skip_before_action :authenticate_user!

    def show
        @product = Product.includes(:accessories, :skus).published.find(params[:id])
        @cart_item = CartItem.new
        @cart_item_accessory = @cart_item.build_cart_item_accessory unless @product.accessories.empty?
        @skus = @product.skus.active.order('cast(attribute_value as integer) asc')
    end  
end
