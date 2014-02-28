FactoryGirl.define do
    factory :cart_item do
        sequence(:price) { |n| n }
        sequence(:quantity) { |n| n }
        sequence(:weight) { |n| n }

        association :sku
        association :cart

        factory :accessory_cart_item do
            after(:create) do |cart_item, evaluator|
                create(:cart_item_accessory, cart_item: cart_item)
            end
        end
    end
end