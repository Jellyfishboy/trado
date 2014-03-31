require 'mailatron_4000/orders'
require 'mailatron_4000/stock'

module Mailatron4000

    # Marks a notification as sent and records the time
    #
    # @return [Mailatron4000.notification_sent]
    # @parameter [hash object]
    def self.notification_sent(notification)
        notification.sent = true
        notification.sent_at = Time.now
        notification.save!
    end

end