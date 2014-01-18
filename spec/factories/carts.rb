FactoryGirl.define do
    factory :cart do
        ignore do
            cart_item_count 3
        end

        after(:create) do |cart, evaluator|
            create_list(:cart_item, evaluator.cart_item_count, cart: cart)
        end
    end
end