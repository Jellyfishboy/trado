module Mailatron4000
    class Orders

        # Depending on the payment_status of the order, the relevant email template is sent
        #
        # @param order [Object]
        def self.confirmation_email order
            if order.transactions.last.completed?
                OrderMailer.completed(order).deliver_later
            elsif order.transactions.last.pending?
                OrderMailer.pending(order).deliver_later
            elsif order.transactions.last.failed?
                OrderMailer.failed(order).deliver_later
            end
        end

    end
end