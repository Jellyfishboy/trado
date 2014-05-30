class StockMailer < ActionMailer::Base
    helper :application, :product
    layout 'email'
    default :from => "Tom Dallimore <tom.alan.dallimore@googlemail.com>"

    # Deliver an email detailing a collection of products which are low on stock to the administrator
    #
    # @param products [Array]
    def low products
        @restock = products
        
        mail(to: 'tom.alan.dallimore@googlemail.com', 
             subject: 'Gimson Robotics Restock Warning',
             template_path: 'mailer/stock',
             template_name: 'low'
        )
    end

    # Deliver an email to the customer when a product SKU is back in stock
    # This is only triggered if the customer has submitted their email address for notifications on the related product SKU
    #
    # @param sku [Object]
    # @param email [String]
    def notification sku, email
        @sku = sku
        @email = email
        mail(to: email, 
             subject: "Stock reminder for #{@sku.product.name}",
             template_path: 'mailer/stock',
             template_name: 'notification'
        )
    end
end