FactoryGirl.define do
    factory :product do
        sequence(:name)  { |n| "#{Faker::Lorem.characters(10)}#{n}" }
        meta_description { Faker::Lorem.characters(10) }
        short_description { Faker::Lorem.characters(15) } 
        description { Faker::Lorem.characters(20) }
        sku { Faker::Lorem.characters(5) }
        sequence(:part_number) { |n| "GA#{n}" }
        featured false
        active true
        sequence(:weighting) { |n| n }

        association :category
    end
end