FactoryGirl.define do 
    factory :accessory do
        name "Accessory #1"
        sequence(:part_number) { |n| n }
    end
end