class SendDispatchedOrderEmails < ActiveJob::Base
    queue_as :mailers

    def perform
        Order.active.pending.dispatch_today_or_past.each do |order|
            if order.shipping_date.hour == Time.current.hour
                OrderMailer.dispatched(order).deliver_later
                order.dispatched!
            end
        end
    end
end
