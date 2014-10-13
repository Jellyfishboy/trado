class OrderMailer < ActionMailer::Base

    # Deliver an email to the customer when an order has been completed
    #
    # @param order [Object]
    def completed order
        @order = order

        mail(to: order.email, 
            from: "#{Store::settings.name} <#{Store::settings.email}>",
            subject: "#{Store::settings.name} ##{@order.id} order confirmation"
        ) do |format|
            format.html { render "themes/#{Store::settings.theme.name}/emails/orders/completed", layout: "../themes/#{Store::settings.theme.name}/layout/email" }
            format.text { render "themes/#{Store::settings.theme.name}/emails/orders/completed", layout: "../themes/#{Store::settings.theme.name}/layout/email" }
        end
    end

    # Deliver an email to the customer when a payment is currently pending for an order
    # This applys to the Paypal checkout process only
    #
    # @param order [Object]
    def pending order
        @order = order

        mail(to: order.email, 
            from: "#{Store::settings.name} <#{Store::settings.email}>",
            subject: "#{Store::settings.name} ##{@order.id} pending payment"
        ) do |format|
            format.html { render "themes/#{Store::settings.theme.name}/emails/orders/pending", layout: "../themes/#{Store::settings.theme.name}/layout/email" }
            format.text { render "themes/#{Store::settings.theme.name}/emails/orders/pending", layout: "../themes/#{Store::settings.theme.name}/layout/email" }
        end
    end

    # Deliver an email to the customer if the 
    # This applys to the Paypal checkout process only
    #
    # @param order [Object]
    def failed order
        @order = order
        
        mail(to: order.email, 
            from: "#{Store::settings.name} <#{Store::settings.email}>",
            subject: "#{Store::settings.name} ##{@order.id} failed"
        ) do |format|
            format.html { render "themes/#{Store::settings.theme.name}/emails/orders/failed", layout: "../themes/#{Store::settings.theme.name}/layout/email" }
            format.text { render "themes/#{Store::settings.theme.name}/emails/orders/failed", layout: "../themes/#{Store::settings.theme.name}/layout/email" }
        end
    end

    # Deliver an email to the customer when the order has been set to dispatched
    #
    # @param order [Object]
    def dispatched order
        @order = order

        mail(to: order.email,
            from: "#{Store::settings.name} <#{Store::settings.email}>", 
            subject: "#{Store::settings.name} ##{@order.id} order shipped"
        ) do |format|
            format.html { render "themes/#{Store::settings.theme.name}/emails/orders/dispatched", layout: "../themes/#{Store::settings.theme.name}/layout/email" }
            format.text { render "themes/#{Store::settings.theme.name}/emails/orders/dispatched", layout: "../themes/#{Store::settings.theme.name}/layout/email" }
        end
    end
end