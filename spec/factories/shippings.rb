FactoryGirl.define do
    factory :shipping do
        name { Faker::Lorem.characters(10) }
        price { |n| n }
        description { Faker::Lorem.characters(99) }
        active true
    end
end