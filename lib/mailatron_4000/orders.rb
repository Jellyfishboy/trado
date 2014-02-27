module Mailatron4000
    class Orders

        def self.dispatch_all
            Order.all.each do |order|
                if order.shipping_date == Date.today
                    order.update_column(:shipping_status, "Dispatched")
                    Notifier.order_shipped(order).deliver
                end
            end
        end

    end
end