module DeliveryServicePriceHelper

    def dimension_range min, max
        [min, max].join(' - ')
    end

    def cart_delivery_price cart_delivery_price
        return cart_delivery_price.nil? ? 0 : cart_delivery_price.price
    end
end