module DeliveryServicePriceHelper

    def dimension_range min, max
        [min, max].join(' - ')
    end
end