require 'payatron_4000/paypal'
require 'payatron_4000/generic'

module Payatron4000

    class << self

        # Convert a price into single digit currency
        #
        # @parameter [decimal]
        # @return [decimal]
        def singularize_price price
            (price*100).round
        end

        # Creates a new stock level record for each order_item SKU, adding the order id to the description
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

        # Destroys the cart and any associated cart_item & cart_items_accesory records
        # and sets the cart_id session value to nil
        # 
        # @parameter [hash object]
        def destroy_cart session
            Cart.destroy(session[:cart_id])
            session[:cart_id] = nil
        end

        # If address exists for an order, find and utilise it. If not, create a new address record
        #
        # @parameter [integer, integer]
        def select_address order_id, address_id
            if address_id
                Address.find(address_id)
            else
                Address.new(:addressable_id => order_id, :addressable_type => 'Order')
            end
        end

        # Depending on the payment_status of the order, the relevant email template is sent
        #
        # @parameter [hash object, string]
        def confirmation_email order, payment_status
            if payment_status == "Pending"
                OrderMailer.pending(order).deliver
            else
                OrderMailer.received(order).deliver
            end
        end
    end  
end