module ProductHelper

    def accessory_details accessory
        "#{accessory.name} (+#{Store::Price.new(price: accessory.price).single})".html_safe
    end

    def product_filter_classes product
        product_category = product.category.nil? ? nil : " category-#{product.category.slug}"
        product_featured = product.featured? ? " product-featured" : nil
        return "product-#{product.status}#{product_category}#{product_featured}"
    end

    def render_variants sku
        sku.variants.map{|v| v.name}.join(' / ')
    end

    def check_stock product
        product.in_stock? ? "IN STOCK" : "OUT OF STOCK"
    end
end