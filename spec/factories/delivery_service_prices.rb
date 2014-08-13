FactoryGirl.define do
    factory :delivery_service_price do
        code { Faker::Lorem.word }
        sequence(:price) { |n| n }
        description { Faker::Lorem.characters(100) }
        sequence(:min_weight) { |n| n }
        sequence(:max_weight) { |n| n }
        sequence(:min_length) { |n| n }
        sequence(:max_length) { |n| n }
        sequence(:min_thickness) { |n| n }
        sequence(:max_thickness) { |n| n }
        active { false }

        association :delivery_service
    end
end