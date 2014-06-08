module Shipatron4000

    class << self

        # Calculate the relevant shipping tiers for an order, taking into account length, thickness and weight of the total order
        #
        # @param cart [Object]
        # @return [Array] calculated tiers for the current cart dimensions
        def tier cart
            max_length = cart.skus.map(&:length).max
            max_thickness = cart.skus.map(&:thickness).max
            total_weight = cart.cart_items.map(&:weight).sum
            
            return Tier.where('? >= length_start AND ? <= length_end AND ? >= thickness_start AND ? <= thickness_end AND ? >= weight_start AND ? <= weight_end', max_length, max_length, max_thickness, max_thickness, total_weight, total_weight).pluck(:id)
        end
    end
end