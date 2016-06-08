class StockMailer < ActionMailer::Base
    helper :application, :product

    # Deliver an email to the customer when a product SKU is back in stock
    # This is only triggered if the customer has submitted their email address for notifications on the related product SKU
    #
    # @param sku [Object]
    # @param email [String]
    def notification sku, email
        @sku = sku
        @email = email
        mail(to: email, 
            from: "#{Store.settings.name} <#{Store.settings.email}>",
            subject: "#{@sku.product.name} Stock Reminder"
        ) do |format|
            format.html { render "themes/#{Store.settings.theme.name}/emails/stock/notification", layout: "../themes/#{Store.settings.theme.name}/layout/email" }
            format.text { render "themes/#{Store.settings.theme.name}/emails/stock/notification", layout: "../themes/#{Store.settings.theme.name}/layout/email" }
        end
    end
end