FactoryGirl.define do
    factory :order_item do
        sequence(:price) { |n| n }
        sequence(:quantity) { |n| n }
        sequence(:weight) { |n| n }

        association :sku
        association :order
    end
end