class ShippingMailerPreview
  def complete
    order = Order.new
    ShippingMailer.complete(order)
  end


  # def delayed
  #   ShippingMailer.delayed order
  # end
end
