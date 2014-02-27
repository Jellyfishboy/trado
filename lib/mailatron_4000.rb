require 'mailatron_4000/orders'
require 'mailatron_4000/stock'

module Mailatron4000

    def self.notification_sent(notification)
        notification.sent = true
        notification.sent_at = Time.now
        notification.save!
    end

end