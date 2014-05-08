module Mailatron4000
    class Stock

        def self.warning
            @restock = Sku.where('stock < stock_warning_level').all
            StockMailer.low(@restock).deliver unless @restock.nil?
        end

        def self.notify
            @skus = Sku.where('stock > stock_warning_level').joins("INNER JOIN notifications ON skus.id = notifications.notifiable_id").where('notifications.sent = ? ', false)
            @skus.each do |sku|
                sku.notifications.each do |notify|
                    StockMailer.notification(sku, notify.email).deliver
                    Mailatron4000::notification_sent(notify)
                end
            end
        end

    end
end