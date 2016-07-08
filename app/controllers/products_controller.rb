class ProductsController < ApplicationController
  skip_before_action :authenticate_user!

    def show
        set_product
        set_skus
        set_variant_types
        new_cart_item
        new_cart_item_accessory
        render theme_presenter.page_template_path('products/show'), layout: theme_presenter.layout_template_path
    end  

    private

    def set_product
        @product = Product.includes(:accessories, :skus, :category, :variant_types, :variants, :attachments).active.published.find(params[:id])
    end

    def set_skus
        @skus = @product.active_skus
    end

    def set_variant_types
        @variant_types ||= VariantType.all
    end

    def new_cart_item
        @cart_item = CartItem.new
    end

    def new_cart_item_accessory
        @cart_item_accessory = @cart_item.build_cart_item_accessory unless @product.accessories.empty?
    end
end
