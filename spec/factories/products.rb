FactoryGirl.define do
    factory :product do
        name { Faker::Lorem.characters(10) }
        meta_description { Faker::Lorem.characters(10) }
        description { Faker::Lorem.characters(20) }
        sequence(:weighting) { |n| n }
        sku { Faker::Lorem.characters(5) }
        sequence(:part_number) { |n| n }
        featured false
    end
end