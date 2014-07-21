class OrderMailerPreview < BasePreview

    def received
        OrderMailer.received(mock_order)
    end


    def pending
        OrderMailer.pending(mock_order)
    end
end
