module Mailatron4000
    class Orders

        def self.dispatch_all
            Order.all.each do |order|
                if order.shipping_date.to_date == Date.today
                    order.update_column(:shipping_status, "Dispatched")
                    ShippingMailer.complete(order).deliver
                end
            end
        end

    end
end