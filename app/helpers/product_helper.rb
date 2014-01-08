module ProductHelper

    def sku_attribute_values sku
        "#{sku.attribute_value} #{sku.attribute_type.measurement unless sku.attribute_type.measurement.nil?}"
    end

end