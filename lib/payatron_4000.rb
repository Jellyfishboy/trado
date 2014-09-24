require 'payatron_4000/paypal'
require 'payatron_4000/generic'

module Payatron4000

    class << self

        def select_pay_provider cart, order, payment_type, ip_address
            if payment_type == 'paypal'
                return Payatron4000::Paypal.build_order(cart, order, ip_address)
            end
        end

        # Creates a new stock level record for each order_item SKU, adding the order id to the description
        # Also updates the related SKU's stock value
        #
        # @param order [Object]
        def update_stock order
            order.order_items.each do |item|
              sku = Sku.find(item.sku_id)
              description = item.order_item_accessory.nil? ? "Order ##{order.id}" : "Order ##{order.id} (+ #{item.order_item_accessory.accessory.name})"
              StockLevel.create(description: description, adjustment: "-#{item.quantity}", sku_id: item.sku_id)
              sku.update_column(:stock, sku.stock-item.quantity)
            end
        end

        # Destroys the cart and any associated cart_item & cart_items_accesory records
        # and sets the cart_id session value to nil
        # 
        # @param session [Object]
        def destroy_cart session
            Cart.destroy(session[:cart_id])
            session[:cart_id] = nil
        end      

        # Increments the order count attribute for each product in an order by one
        # The order count attribute is used for determing popularity in the store sorting tool
        #
        # @param products [Array]
        def increment_product_order_count products
            products.each do |product|
                product.increment!(:order_count)
            end
        end
    end  
end