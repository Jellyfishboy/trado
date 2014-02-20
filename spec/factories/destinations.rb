FactoryGirl.define do
    factory :destination do
        association :zone
        association :shipping
    end
end