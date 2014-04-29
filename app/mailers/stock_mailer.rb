class StockMailer < ActionMailer::Base
    layout 'email'
    default :from => "Tom Dallimore <tom.alan.dallimore@googlemail.com>"

    # Deliver an email detailing a collection of products which are low on stock to the administrator
    #
    # @parameter [array]
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
    # @parameter [object], [string]
    def notification sku, email
        @sku = sku

        mail(to: email, 
             subject: "#{@sku.product.name} is now in stock!",
             template_path: 'mailer/stock',
             template_name: 'notification'
        )
    end
end