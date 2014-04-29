class ShippingMailerPreview
  def complete
    ShippingMailer.complete order
  end


  def delayed
    ShippingMailer.delayed order
  end
end
