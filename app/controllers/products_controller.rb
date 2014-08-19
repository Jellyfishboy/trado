class ProductsController < ApplicationController

  skip_before_action :authenticate_user!
  
  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.includes(:accessories, :skus).find(params[:id])
    @cart_item = CartItem.new
    @cart_item_accessory = @cart_item.build_cart_item_accessory unless @product.accessories.empty?
    @notification = Notification.new
    @skus = @product.skus.active.order('cast(attribute_value as integer) asc')
  end
  
end
