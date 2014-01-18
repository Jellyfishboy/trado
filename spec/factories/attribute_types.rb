FactoryGirl.define do
    factory :attribute_type do
        name { Faker::Lorem.word }
        measurement { Faker::Lorem.word }
    end
end