FactoryGirl.define do
    factory :tagging do

        association :product
        association :tag
    end
end