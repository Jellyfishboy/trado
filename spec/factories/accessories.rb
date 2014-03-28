FactoryGirl.define do 
    factory :accessory do
        sequence(:name)  { |n| "#{Faker::Lorem.word}#{Faker::Lorem.characters(8)}#{n}" }
        sequence(:part_number) { |n| n }
        sequence(:price) { |n| n }
        sequence(:weight) { |n| n }
        sequence(:cost_value) { |n| n }
        active false
        
        factory :invalid_accessory do
            name nil
        end
    end
end