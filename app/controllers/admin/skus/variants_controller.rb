class Admin::Skus::VariantsController < ApplicationController
    before_filter :authenticate_user!

    def new
        set_product
        set_variant_types
        render json: { modal: render_to_string(partial: 'admin/products/skus/variants/modal'), active_skus: !@product.skus.active.empty? }, status: 200
    end

    def create
        set_product
        set_variant_types
        @variants = @variant_types.map do |type|
            next if params[type.name.downcase.to_sym].blank? || params[type.name.downcase.to_sym].nil?
            {
                id: type.id,
                values: params[type.name.downcase.to_sym].split(/,\s*/),
                count: params[type.name.downcase.to_sym].split(/,\s*/).count,
            }
        end.reject(&:nil?)
        if @variants.empty?
            render json: { errors: ['Variant options can\'t be blank'] }, status: 422
        else
            @total_possible_skus = @variants.map do |v| 
                v[:values].count == 0 ? 1 : v[:values].count
            end.inject(:*)

            @skus = []
            @total_possible_skus.times do
                sku = @product.skus.build
                sku.save(validate: false)
                @skus << sku
            end
            @variants.each_with_index do |variant, index|
                possible_variants = @total_possible_skus/variant[:count]
                values = variant[:values]*possible_variants
                values = index != 0 ? values.sort_by!{|v| v.downcase } : values
                @skus.zip(values).each do |sku, value|
                    break if value.nil?
                    SkuVariant.create(sku_id: sku.id, name: value, variant_type_id: variant[:id])
                end
            end

            render partial: 'admin/products/skus/variants/create', format: [:js], locals: { sku_count: @total_possible_skus }
        end
    end

    def update
        set_product
        set_variant_types
        @variant_array = []
        @variant_types.each do |type|
            @variant_array << params[type.name.downcase.to_sym].split(/,\s*/)
        end
        @variant_array = @variant_array.flatten
        @delete_variants = @product.skus.includes(:variants).where.not(sku_variants: { name: @variant_array.reject(&:empty?) } )
        @variant_count = @delete_variants.count
        @delete_variants.destroy_all

        render partial: 'admin/products/skus/variants/update', format: [:js], locals: { variant_count: @variant_count }
    end

    def destroy
        set_product
        @product.skus.active.each do |sku|
            Store.active_archive(CartItem, :sku_id, sku)
        end
        render partial: 'admin/products/skus/variants/destroy', format: [:js]
    end

    private

    def set_product
        @product = Product.find(params[:product_id])
    end

    def set_variant_types
        @variant_types = VariantType.all
    end
end