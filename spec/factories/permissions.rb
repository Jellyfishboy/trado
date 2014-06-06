FactoryGirl.define do
    factory :permission do
        association :user
        association :role
    end
end
