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

        # Creates a new stock level record for each order item SKU, adding the order id to the description
        # Also updates the related SKU's stock value
        #
        # @return [Payatron4000::stock_update]
        # @parameter [hash object]
        def stock_update order
            order.order_items.each do |item|
              sku = Sku.find(item.sku_id)
              StockLevel.create(:description => "Order ##{order.id}", :adjustment => "-#{item.quantity}", :sku_id => item.sku_id)
              sku.update_column(:stock, sku.stock-item.quantity)
            end
        end
    end  
end