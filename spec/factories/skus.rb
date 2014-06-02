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
        sequence(:attribute_value) { |n| "#{Faker::Lorem.word}#{n}" }
        active { false }

        association :attribute_type
        association :product

        factory :sku_in_stock do
            after(:create) do |sku, evaluator|
                create(:sku_notification, notifiable: sku)
            end
        end

        factory :sku_stock_level do
            after(:create) do |sku, evaluator|
                create(:stock_level, adjustment: 3, sku: sku)
            end
        end
    end
end