FactoryGirl.define do
    factory :shipping do
        name { Faker::Lorem.characters(10) }
        sequence(:price) { |n| n }
        description { Faker::Lorem.characters(99) }
        active false
    end
end