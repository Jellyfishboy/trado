class Admin::Skus::VariantsController < ApplicationController
    before_filter :authenticate_user!
    before_filter :set_product
    before_filter :set_variant_types, except: :destroy

    def new
        render partial: 'admin/products/skus/variants/new', format: [:js]
    end

    def create
        @variants = @variant_types.map do |type|
            {
                id: type.id,
                values: params[type.name.downcase.to_sym].split(/,\s*/)
            }
        end
        @total_skus = @variants.map do |v| 
            v[:values].count == 0 ? 1 : v[:values].count
        end.inject(:*)

        @skus = []
        @total_skus.times do
            sku = @product.skus.build
            sku.save(validate: false)
            @skus << sku
        end
        
        @variants.each do |variant|
            next if variant[:values].empty?
            iteration = @total_skus/variant[:values].count
            @skus.zip(variant[:values]*iteration).each do |sku, value|
                break if value.nil?
                SkuVariant.create(sku_id: sku.id, name: value, variant_type_id: variant[:id])
            end
        end
        render partial: 'admin/products/skus/variants/create', format: [:js], locals: { sku_count: @total_skus }
    end

    def destroy

    end

    private

    def set_product
        @product = Product.find(params[:product_id])
    end

    def set_variant_types
        @variant_types = VariantType.all
    end
end