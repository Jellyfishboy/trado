FactoryGirl.define do
    factory :product do
        name { Faker::Lorem.characters(10) }
        meta_description { Faker::Lorem.characters(10) }
        short_description { Faker::Lorem.characters(15) } 
        description { Faker::Lorem.characters(20) }
        sku { Faker::Lorem.characters(5) }
        sequence(:part_number) { |n| n }
        featured false
        active true

        association :category
    end
end