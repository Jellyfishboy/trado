FactoryGirl.define do
    factory :country do
        name { Faker::Address.country }
    end
end