module ProductHelper

    def sku_attribute_values sku, single
        "#{sku.attribute_value} #{sku.attribute_type.measurement unless sku.attribute_type.measurement.nil?}" unless single
    end

    def accessory_details accessory
        "#{accessory.name} (+#{Store::Price.new(price: accessory.price).single})".html_safe
    end

    def coloured_row adjustment
        Store::positive?(adjustment) ? "tr-green" : "tr-red"
    end

    def product_filter_classes product
        product_category = product.category.nil? ? nil : " category-#{product.category.slug}"
        product_featured = product.featured? ? " product-featured" : nil
        return "product-#{product.status}#{product_category}#{product_featured}"
    end
end