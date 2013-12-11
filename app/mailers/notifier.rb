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

    mail :to => order.email, :subject => "Gimson Robotics ##{order.id} order confirmation"
  end

  def order_updated(order)
    @order = order

    mail :to => order.email, :subject => "Gimson Robotics ##{order.id} order update"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_shipped.subject
  #
  def order_shipped(order)
    @order = order

    mail :to => order.email, :subject => 'Gimson Robotics ##{order.id} order shipped'
  end

  def shipping_updated(order)
    @order = order

    mail :to => order.email, :subject => "Gimson Robotics ##{@order.id} shipping update"
  end

  def application_error(error, obj)
    @error_log = error
    @obj = obj

    mail :to => "tom.alan.dallimore@googlemail.com", :subject => "Application Error: #{@obj}"
  end

  def low_stock(products)
    @restock = products
    mail :to => 'tom.alan.dallimore@googlemail.com', :subject => 'Restock Warning'
  end

end
