module ProductHelper

    def sku_attribute_values sku
        "#{sku.attribute_value} #{sku.attribute_type.measurement unless sku.attribute_type.measurement.nil?}"
    end

    def gross_price  net_price
      format_currency net_price*0.2 + net_price
    end

    def accessory_details accessory
        "#{accessory.name} (+#{format_currency(accessory.price)})".html_safe
    end

end