class OrderMailer < ActionMailer::Base
    layout 'email'
    default :from => "Tom Dallimore <tom.alan.dallimore@googlemail.com>"

    # Deliver an email to the customer when an order has been completed
    #
    # @param order [Object]
    def completed order
        @order = order

        mail(to: order.email, 
             subject: "Gimson Robotics ##{@order.id} order confirmation",
             template_path: 'mailer/orders',
             template_name: 'completed'
        )
    end

    # Deliver an email to the customer when a payment is currently pending for an order
    # This applys to the Paypal checkout process only
    #
    # @param order [Object]
    def pending order
        @order = order

        mail(to: order.email, 
             subject: "Gimson Robotics ##{@order.id} pending payment",
             template_path: 'mailer/orders',
             template_name: 'pending'
        )
    end

    # Deliver an email to the customer if the 
    # This applys to the Paypal checkout process only
    #
    # @param order [Object]
    def failed order
        @order = order
        
        mail(to: order.email, 
             subject: "Gimson Robotics ##{@order.id} failed",
             template_path: 'mailer/orders',
             template_name: 'failed'
        )
    end

    # Deliver an email to the customer when the order has been set to dispatched
    #
    # @param order [Object]
    def dispatched order
        @order = order

        mail(to: order.email, 
             subject: "Gimson Robotics ##{@order.id} order shipped",
             template_path: 'mailer/orders',
             template_name: 'dispatched'
        )
    end
end