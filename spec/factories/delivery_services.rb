FactoryGirl.define do
    factory :delivery_service do
        name { Faker::Lorem.word }
        description { Faker::Lorem.characters(50) }
        courier_name { Faker::Lorem.word }
        active { false }

        factory :invalid_delivery_service do
            name { nil }
        end
    end
end
