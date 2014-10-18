FactoryGirl.define do
    factory :delivery_service_price do
        sequence(:code) { |n| "#{Faker::Lorem.word}#{n}" }
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

        factory :invalid_delivery_service_price do
            code { nil }
        end
    end
end