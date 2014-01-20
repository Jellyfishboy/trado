FactoryGirl.define do 
    factory :accessory do
        name { Faker::Lorem.word }
        sequence(:part_number) { |n| n }

        factory :invalid_accessory do
            name nil
        end
    end
end