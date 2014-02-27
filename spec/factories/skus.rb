FactoryGirl.define do
    factory :sku do
        sku { |n| "5#{n}" }
        sequence(:cost_value) { |n| n }
        sequence(:price) { |n| n }
        stock 30
        stock_warning_level 5
        sequence(:length) { |n| n }
        sequence(:weight) { |n| n }
        sequence(:thickness) { |n| n }
        attribute_value { Faker::Lorem.word }
        active true

        association :attribute_type
        association :product
        association :accessory

        factory :sku_in_stock do
            after(:create) do |sku, evaluator|
                create(:sku_notification)
            end
        end
    end
end