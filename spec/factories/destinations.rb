FactoryGirl.define do
    factory :destination do
        association :country
        association :delivery_service
    end
end