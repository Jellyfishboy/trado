require 'payatron_4000/paypal'

module Payatron4000

    class << self

        # Convert a price into single digit currency
        #
        # @return [Payatron4000::price_in_pennies]
        # @parameter [decimal]
        def price_in_pennies price
            (price*100).round
        end

        # Updates the stock after a purchase has been completed
        #
        # @return [Payatron4000::stock_update]
        # @parameter [hash object]
        def stock_update order
            order.order_items.each do |item|
              sku = Sku.find(item.sku_id)
              sku.update_column(:stock, sku.stock-item.quantity)
            end
        end
    end  
end