class StockMailerPreview < BasePreview

    def low
        StockMailer.low(mock_skus)
    end


    def notification
        StockMailer.notification(mock_sku, Store::settings.email)
    end
end
