class StockMailerPreview < BasePreview

    def low
        StockMailer.low(mock_products)
    end


    def notification
        StockMailer.notification(mock_sku, Store::settings.email)
    end
end
