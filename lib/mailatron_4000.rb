require 'mailatron_4000/orders'

module Mailatron4000

    class << self

        # Marks a notification as sent and records the time
        #
        # @param notification [Object]
        def notification_sent notification
            notification.sent = true
            notification.sent_at = Time.now
            notification.save!
        end
    end
end