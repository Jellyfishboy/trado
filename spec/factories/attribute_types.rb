FactoryGirl.define do
    factory :attribute_type do
        name { Faker::Lorem.word }
        measurement { Faker::Lorem.word }

        factory :invalid_attribute_type do
            name { nil }
        end
    end
end