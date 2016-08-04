module HasShippingDateValidation
    extend ActiveSupport::Concern

    included do
        validates :shipping_date,                                             presence: true, if: :validate_shipping_date

        attr_accessor :validate_shipping_date
        after_initialize :set_validate_shipping_date

        def validate_shipping_date!
            @validate_shipping_date = true
        end
    end

    def set_validate_shipping_date
        @validate_shipping_date = false
    end
end