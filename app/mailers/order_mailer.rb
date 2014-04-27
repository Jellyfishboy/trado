class OrderMailer < ActionMailer::Base
    default :from => "Tom Dallimore <tom.alan.dallimore@googlemail.com>"

    # Deliver an email to the customer when an order has been received
    #
    # @parameter [object]
    def received order
        @order = order

        mail(to: order.email, 
             subject: "Gimson Robotics ##{@order.id} order confirmation",
             template_path: 'mailer/orders',
             template_name: 'received'
        )
    end

    # Deliver an email to the customer when a payment is currently pending for an order
    # This applys to the Paypal checkout process only
    #
    # @parameter [object]
    def pending order
        @order = order

        mail(to: order.email, 
             subject: "Gimson Robotics ##{@order.id} pending payment",
             template_path: 'mailer/orders',
             template_name: 'pending'
        )
    end
end