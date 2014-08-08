module Mailatron4000
    class Orders

        # Iterate through all order records which have a shipping status of 'pending'
        # If their shipping date is today, mark as dispatched and send an email
        #
        def self.dispatch_all
            Order.pending.each do |order|
                if order.shipping_date.to_date == Date.today
                    order.dispatched!
                    OrderMailer.dispatched(order).deliver
                end
            end
        end

        # Depending on the payment_status of the order, the relevant email template is sent
        #
        # @param order [Object]
        def self.confirmation_email order
            if order.transactions.last.completed?
                OrderMailer.completed(order).deliver
            elsif order.transactions.last.pending?
                OrderMailer.pending(order).deliver
            elsif order.transactions.last.failed?
                OrderMailer.failed(order).deliver
            end
        end

    end
end