class SendDispatchedOrderEmails < ActiveJob::Base
    queue_as :mailers

    def perform
        Order.dispatch_today.pending.each do |order|
            if order.shipping_date.hour == Time.now.hour
                OrderMailer.dispatched(order).deliver_later
                order.dispatched!
            end
        end
    end
end
