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

        # Depending on the payment_status of the order, the relevant email template is sent
        #
        # @param order [Object]
        def self.confirmation_email order
            if order.transactions.last.payment_status == "Completed"
                OrderMailer.received(order).deliver
            elsif order.transactions.last.payment_status == "Pending"
                OrderMailer.pending(order).deliver
            else
                OrderMailer.failed(order).deliver
            end
        end

    end
end