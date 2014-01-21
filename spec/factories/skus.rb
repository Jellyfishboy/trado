FactoryGirl.define do
    factory :sku do
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
    end
end