class ShippingMailerPreview < BasePreview

    def complete
        ShippingMailer.complete(mock_order)
    end
end
