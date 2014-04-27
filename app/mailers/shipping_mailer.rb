class ShippingMailer < ActionMailer::Base
    default :from => "Tom Dallimore <tom.alan.dallimore@googlemail.com>"

    # Deliver an email to the customer when an order has been shipped
    #
    # @parameter [object]
    def complete order
        @order = order

        mail(to: order.email, 
             subject: "Gimson Robotics ##{@order.id} order shipped",
             template_path: 'mailer/shippings',
             template_name: 'shipped'
        )
    end

    # Deliver an email to the customer when an order has been delayed
    # This is only triggered when a shipping date has been set more than once on an order
    #
    # @parameter [object]
    def delayed order
        @order = order

        mail(to: order.email, 
             subject: "Gimson Robotics ##{@order.id} shipping update",
             template_path: 'mailer/shippings',
             template_name: 'delayed'
        )
    end
end