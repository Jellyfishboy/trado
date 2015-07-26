module HasSkus
    extend ActiveSupport::Concern

    included do
        validate :sku_count,                                        :if => :published?
        validate :sku_attributes,                                   :if => :published?

        accepts_nested_attributes_for :skus
    end

    # Calculate if a product has at least one associated SKU
    # If no associated SKUs exist, return an error
    #
    def sku_count
        if self.skus.map(&:active).count == 0
            errors.add(:product, " must have at least one variant.")
            return false
        end
    end

    # Checks if all the associated skus are valid when publishing the product
    # If not, returns a helpful error for the user
    # 
    def sku_attributes
        if self.skus.active.map(&:valid?).include?(false)
            errors.add(:base, "You must complete all variants before publishing the product.")
            return false
        end
    end
end