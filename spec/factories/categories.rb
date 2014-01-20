FactoryGirl.define do
    factory :category do
        name { Faker::Lorem.word }
        description { Faker::Lorem.paragraph(1) }
        visible true

        factory :invalid_category do
            name nil
        end
    end
end