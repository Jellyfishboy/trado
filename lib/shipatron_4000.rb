module Shipatron4000

    class << self

        # Calculate the relevant shipping tiers for an order, taking into account length, thickness and weight of the total order
        #
        # @param cart [Object]
        # @param order [Ojbect]
        # @return [Array] calculated tiers for the current cart dimensions
        def delivery_prices cart, order
            length = cart.skus.map(&:length).max
            thickness = cart.skus.map(&:thickness).max
            total_weight = cart.cart_items.map(&:weight).sum
            delivery_service_prices = DeliveryServicePrice.where('? >= min_weight AND ? <= max_weight AND ? >= min_length AND ? <= max_length AND ? >= min_thickness AND ? <= max_thickness', total_weight, total_weight, length, length, thickness, thickness).pluck(:id)
            order.update_column(:delivery_service_prices, delivery_service_prices)
        end
    end
end