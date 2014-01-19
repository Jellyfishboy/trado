FactoryGirl.define do
    factory :destination do
        association :country
        association :shipping
    end
end