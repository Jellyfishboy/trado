module HasOrderAddresses
    extend ActiveSupport::Concern

    included do
        has_one :delivery_address,                                            -> { where addressable_type: 'OrderDeliveryAddress'}, class_name: 'Address', foreign_key: 'addressable_id', dependent: :destroy
        has_one :delivery_address_country,                                    through: :delivery_address, source: :country
        has_one :billing_address,                                             -> { where addressable_type: 'OrderBillAddress'}, class_name: 'Address', foreign_key: 'addressable_id', dependent: :destroy
        has_one :billing_address_country,                                     through: :billing_address, source: :country

        accepts_nested_attributes_for :delivery_address
        accepts_nested_attributes_for :billing_address

        after_initialize :build_addresses

        def build_addresses
            if new_record?
                build_delivery_address if delivery_address.nil?
                build_billing_address if billing_address.nil?
            end
        end
    end
end