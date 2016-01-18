class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

    def show
        @product = Product.includes(:accessories, :skus, :category, :variant_types, :variants).active.published.find(params[:id])
        @cart_item = CartItem.new
        @cart_item_accessory = @cart_item.build_cart_item_accessory unless @product.accessories.empty?
        @skus = @product.skus.active

        render theme_presenter.page_template_path('products/show'), layout: theme_presenter.layout_template_path
    end  
end
