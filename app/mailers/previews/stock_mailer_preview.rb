class StockMailerPreview < BasePreview

    def notification
        StockMailer.notification(mock_sku, Store.settings.email)
    end
end
