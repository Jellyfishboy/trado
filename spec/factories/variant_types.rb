FactoryGirl.define do
    factory :variant_type do
        name { Faker::Lorem.characters(5) }
    end
end