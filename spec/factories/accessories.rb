FactoryGirl.define do 
    factory :accessory do
        name { Faker::Lorem.word }
        sequence(:part_number) { |n| n }
        sequence(:price) { |n| n }
        sequence(:weight) { |n| n }
        sequence(:cost_value) { |n| n }
        active true
        
        factory :invalid_accessory do
            name nil
        end
    end
end