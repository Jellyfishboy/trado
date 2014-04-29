class OrderMailerPreview
  def received
    OrderMailer.received order
  end


  def pending
    OrderMailer.pending order
  end
end
