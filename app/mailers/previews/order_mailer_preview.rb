class OrderMailerPreview < BasePreview

    def completed
        OrderMailer.completed(mock_order)
    end

    def pending
        OrderMailer.pending(mock_order)
    end

    def failed
        OrderMailer.failed(mock_order)
    end

    def dispatched
        OrderMailer.dispatched(mock_order)
    end
end
