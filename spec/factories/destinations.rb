FactoryGirl.define do
    factory :destination do
        association :zone
        association :delivery_service
    end
end