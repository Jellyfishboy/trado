# Base preview class contains mock objects for the email previews
#
class BasePreview

    # Last order record in the database which has it's status set to active
    #
    # @return [object]
    def mock_order
        Order.where(status: 'active').last
    end

    # Last SKU record in the database which has it's active attribute set to true
    #
    # @return [object]
    def mock_sku
        Sku.where(active: true).last
    end

    # Array of the last 5 product records in the database
    #
    # @return [array]
    def mock_products
        Product.last(5)
    end
end