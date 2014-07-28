module Shipatron4000

    class << self

        # Calculate the relevant shipping tiers for an order, taking into account length, thickness and weight of the total order
        #
        # @param cart [Object]
        # @param order [Ojbect]
        # @return [Array] calculated tiers for the current cart dimensions
        def tier cart, order
            max_length = cart.skus.map(&:length).max
            max_thickness = cart.skus.map(&:thickness).max
            total_weight = cart.cart_items.map(&:weight).sum
            tiers = Tier.where('? >= length_start AND ? <= length_end AND ? >= thickness_start AND ? <= thickness_end AND ? >= weight_start AND ? <= weight_end', max_length, max_length, max_thickness, max_thickness, total_weight, total_weight).pluck(:id)
            order.update_column(:tiers, tiers)
        end

        # Querys the database for the correct shippings depending on the tier and country values
        # Returns HTML elements for a collection of shippings
        #
        # @param country [String]
        # @param cart [Object]
        # @return [String] HTML elements for collection of shippings
        def shippings country, cart
            @shipping_id = cart.order.shipping_id unless cart.order.shipping_id.nil?
            @shippings = Shipping.joins(:tiereds, :countries).where(tiereds: { :tier_id => cart.order.tiers }, countries: { :name => country }).order(price: :asc).load
            Renderer.render partial: "orders/shippings/fields"
        end
    end
end