FactoryGirl.define do 
    factory :accessory do
        name { Faker::Lorem.word }
        sequence(:part_number) { |n| n }
    end
end