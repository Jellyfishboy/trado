FactoryGirl.define do
    factory :cart_item do
        price { |n| "#{n}.40" }
        quantity { |n| n }
        weight { |n| "#{n}.25" }

        association :cart
        association :sku
    end
end