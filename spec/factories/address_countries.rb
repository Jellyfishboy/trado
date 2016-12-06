FactoryGirl.define do
    factory :address_country do

        association :address
        association :country
    end
end
