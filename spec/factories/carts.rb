FactoryGirl.define do
    factory :cart do
        
        ignore do
            cart_item_count 3
        end

        factory :full_cart do
            after(:create) do |cart, evaluator|
                create_list(:accessory_cart_item, evaluator.cart_item_count, cart: cart)
                create(:cart_item, cart: cart)
            end
        end

        factory :tier_calculated_cart do
            after(:create) do |cart, evaluator|
                sku_1 = create(:sku, weight: '14.5', length: '67.20', thickness: '12.34')
                sku_2 = create(:sku, weight: '4.67', length: '34.67', thickness: '9.81')
                create(:cart_item, cart: cart, sku_id: sku_1.id)
                create(:cart_item_1, cart: cart, sku_id: sku_2.id)
            end
        end
    end 
end