module Mailatron4000
    class Orders

        # Depending on the payment_status of the order, the relevant email template is sent
        #
        # @param order [Object]
        def self.confirmation_email order
            if order.latest_transaction.completed?
                OrderMailer.completed(order).deliver_later
            elsif order.latest_transaction.pending?
                OrderMailer.pending(order).deliver_later
            elsif order.latest_transaction.failed?
                OrderMailer.failed(order).deliver_later
            end
        end

    end
end