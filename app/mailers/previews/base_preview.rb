# Base preview class contains mock objects for the email previews
#
class BasePreview < ActionMailer::Preview

    # Last order record in the database which has it's status set to active
    #
    # @return [object]
    def mock_order
        Order.complete.last
    end

    # Last SKU record in the database which has it's active attribute set to true
    #
    # @return [object]
    def mock_sku
        Sku.active.last
    end
end