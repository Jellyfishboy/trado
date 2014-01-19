FactoryGirl.define do
    factory :tiered do

        association :shipping
        association :tier
    end
end