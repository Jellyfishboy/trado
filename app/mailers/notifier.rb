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

    mail :to => order.email, :subject => 'Pragmatic Store Order Confirmation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_shipped.subject
  #
  def order_shipped(order)
    @order = order

    mail :to => order.email, :subject => 'Pragmatic Store Order Shipped'
  end

  def changed_shipping(order)
    @order = order

    mail :to => order.email, :subject => "Pragmatic Order ##{@order.id} Shipping update"
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
