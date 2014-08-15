FactoryGirl.define do
    factory :delivery_service do
        name { Faker::Lorem.word }
        description { Faker::Lorem.characters(50) }
        courier_name { Faker::Lorem.word }
        active { false }

        factory :delivery_service_with_zones do
            courier_name { 'Royal Mail' }
            active { true }
            zones { [create(:zone, name: 'EU'),create(:zone, name: 'Asia')]}
        end

        factory :invalid_delivery_service do
            name { nil }
        end
    end
end
