# Notifier is getting too cluttered. Abstracted alot of the logic away from it to ensure clear, concise code.

class MailDaemon

    def self.dispatch_orders
        Order.all.each do |order|
            if order.shipping_date == Date.today
                order.update_column(:shipping_status, "Dispatched")
                Notifier.order_shipped(self).deliver
            end
        end
    end

    def self.warning_level
        @restock = Sku.where('stock < stock_warning_level').all
        if defined?(@restock)
            Notifier.low_stock(@restock).deliver
        end
    end

    def self.notify_of_new_stock
        @skus = Sku.where('stock > stock_warning_level').joins("INNER JOIN notifications ON skus.id = notifications.notifiable_id").where('notifications.sent = ? ', false)
        @skus.each do |sku|
            sku.notifications.each do |notify|
                Notifier.sku_stock_notification(sku, notify.email)
                mark_notification_as_sent(notify)
            end
        end
    end

    def self.mark_notification_as_sent(notification)
        notification.sent = true
        notification.sent_at = Time.now
        notification.save!
    end

end