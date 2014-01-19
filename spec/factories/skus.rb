FactoryGirl.define do
    factory :sku do
        sku { Faker::Lorem.characters(5) }
        cost_value { |n| n }
        price { |n| n }
        stock { |n| n }
        stock_warning_level { |n| n }
        length { |n| n }
        weight { |n| n }
        thickness { |n| n }
        atttribute_value { Faker::Lorem.word }

        association :attribute_type
        association :product
        association :accessory
    end
end