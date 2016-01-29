FactoryGirl.define do
    factory :order_item do
        sequence(:price) { |n| n }
        sequence(:quantity) { |n| n }
        sequence(:weight) { |n| n }

        association :sku
        association :order

        factory :accessory_order_item do
            after(:create) do |order_item|
                create(:order_item_accessory, order_item: order_item)
            end
        end
    end
end