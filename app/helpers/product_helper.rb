module ProductHelper

    def sku_attribute_values sku, single
        "#{sku.attribute_value} #{sku.attribute_type.measurement unless sku.attribute_type.measurement.nil?}" unless single
    end

    def accessory_details accessory
        "#{accessory.name} (+#{Store::Price.new(accessory.price).format})".html_safe
    end

    def coloured_row adjustment
        Store::positive?(adjustment) ? "tr-green" : "tr-red"
    end

end