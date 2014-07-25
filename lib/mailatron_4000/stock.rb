module Mailatron4000
    class Stock

        # Find SKUs which have a lower stock value than their stock warning level
        # Send an email to the administrator detailing which items are running low 
        #
        def self.warning
            @restock = Sku.where('stock < stock_warning_level').all
            StockMailer.low(@restock).deliver unless @restock.nil?
        end

        # Find SKUs which have a lower stock value than their stock warning level and have associated notifications which have not been sent
        # Iterate through the results and send an email to the recipient, marking the notification as sent aswell
        #
        def self.notify
            @skus = Sku.where('stock > stock_warning_level').includes(:notifications).where(:notifications => { :sent => false })
            @skus.each do |sku|
                sku.notifications.each do |notify|
                    StockMailer.notification(sku, notify.email).deliver
                    Mailatron4000::notification_sent(notify)
                end
            end
        end

    end
end