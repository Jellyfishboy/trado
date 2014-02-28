module Mailatron4000
    class Stock

        def self.warning
            @restock = Sku.where('stock < stock_warning_level').all
            if defined?(@restock)
                Notifier.low_stock(@restock).deliver
            end
        end

        def self.notify
            @skus = Sku.where('stock > stock_warning_level').joins("INNER JOIN notifications ON skus.id = notifications.notifiable_id").where('notifications.sent = ? ', false)
            @skus.each do |sku|
                sku.notifications.each do |notify|
                    Notifier.sku_stock_notification(sku, notify.email).deliver
                    Mailatron4000.notification_sent(notify)
                end
            end
        end

    end
end