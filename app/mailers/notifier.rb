class Notifier < ActionMailer::Base
  default :from => "Tom Dallimore <tom.alan.dallimore@googlemail.com>"
  # more defaults can be set at the top of the mailer class

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_received.subject
  #
  def order_received(order) #retrieve argument 'order' and assign it within the method to send to the customers correct email
    @order = order

    mail :to => order.email, :subject => "Gimson Robotics ##{@order.id} order confirmation"
  end

  def order_updated(order)
    @order = order

    mail :to => order.email, :subject => "Gimson Robotics ##{@order.id} order update"
  end
  def delayed_shipping(order)
    @order = order

    mail :to => order.email, :subject => "Gimson Robotics ##{@order.id} shipping update"
  end

  def order_shipped(order)
    @order = order

    mail :to => order.email, :subject => "Gimson Robotics ##{@order.id} order shipped"
  end

  def low_stock(products)
    @restock = products
    mail :to => 'tom.alan.dallimore@googlemail.com', :subject => 'Restock Warning'
  end

  def sku_stock_notification(sku, email)
    @sku = sku
    mail :to => email, :subject => "#{sku.product.name} is now in stock!"
  end

end
