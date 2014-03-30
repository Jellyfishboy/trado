require 'payatron_4000/paypal'

module Payatron4000

    def self.price_in_pennies price
        (price*100).round
    end

    def self.stock_update order
        order.order_items.each do |item|
          sku = Sku.find(item.sku_id)
          sku.update_column(:stock, sku.stock-item.quantity)
        end
    end
    
end