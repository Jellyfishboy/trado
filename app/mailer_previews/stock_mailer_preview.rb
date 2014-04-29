class StockMailerPreview
  def low
    StockMailer.low products
  end


  def notification
    StockMailer.notification sku, email
  end
end
