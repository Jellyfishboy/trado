class StoreMailer < ActionMailer::Base
  default :from => "Tom Dallimore <tom.alan.dallimore@googlemail.com>"

  # Collection of emails for Orders
  #
  class Orders

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

  # Collection of emails for Shippings
  #
  class Shippings

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

  # Collection of emails for Stock
  #
  class Stock

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

end
