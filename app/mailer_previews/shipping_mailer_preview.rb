class ShippingMailerPreview < BasePreview

    def complete
        ShippingMailer.complete(mock_order)
    end


    def delayed
        ShippingMailer.delayed(mock_order)
    end
end
