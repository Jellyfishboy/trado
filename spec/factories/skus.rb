FactoryGirl.define do
    factory :sku do
        code { |n| "5#{n}" }
        sequence(:cost_value) { |n| n }
        sequence(:price) { |n| n }
        stock { 30 }
        stock_warning_level { 5 }
        sequence(:length) { |n| n }
        sequence(:weight) { |n| n }
        sequence(:thickness) { |n| n }
        sequence(:attribute_value) { |n| n }
        active { false }

        association :attribute_type
        association :product

        factory :sku_in_stock do
            after(:create) do |sku, evaluator|
                create(:sku_notification, notifiable: sku)
            end
        end

        factory :positive_stock_level_sku do
            after(:create) do |sku, evaluator|
                create(:stock_level, adjustment: 3, sku: sku)
            end
        end

        factory :negative_stock_level_sku do
            after(:create) do |sku, evaluator|
                create(:stock_level, adjustment: -3, sku: sku)
            end
        end

        factory :cart_item_sku do
            after(:create) do |sku, evaluator|
                create(:cart_item, quantity: 5, sku: sku)
            end
        end
    end
end