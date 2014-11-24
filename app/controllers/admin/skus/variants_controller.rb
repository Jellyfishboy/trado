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
        @total_skus = @variants.map { |v| v[:values].count }.inject(:*)
        @skus = []
        @total_skus.times do
            sku = Sku.new
            sku.save(validate: false)
            @skus << sku
        end
        @variants.each do |variant|
            next if variant[:values].nil?
            iteration = @total_skus/variant[:values].count
            @skus.zip(variant[:values]*iteration).each do |sku, value|
                break if value.nil?
                SkuVariant.create(sku_id: sku.id, name: value, variant_type_id: variant[:id])
            end
        end
        


        # @variant_types.each do |type|
        #     @values =  
        #     next if @values.nil?
        #     @values.each do |value|

        #         SkuVariant.create(:sku_id:, name: value, variant_type_id: type.id)
        #     end
        # end
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