require 'payatron_4000/paypal'
require 'payatron_4000/bank_transfer'
require 'payatron_4000/cheque'

module Payatron4000

    class << self

        # Convert a price into single digit currency
        #
        # @return [decimal]
        # @parameter [decimal]
        def price_in_pennies price
            (price*100).round
        end

        # Creates a new stock level record for each order item SKU, adding the order id to the description
        # Also updates the related SKU's stock value
        #
        # @parameter [hash object]
        def stock_update order
            order.order_items.each do |item|
              sku = Sku.find(item.sku_id)
              description = item.order_item_accessory.nil? ? "Order ##{order.id}" : "Order ##{order.id} (+ #{item.order_item_accessory.accessory.name})"
              StockLevel.create(:description => description, :adjustment => "-#{item.quantity}", :sku_id => item.sku_id)
              sku.update_column(:stock, sku.stock-item.quantity)
            end
        end
    end  
end