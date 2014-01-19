FactoryGirl.define do
    factory :tag do
        name { Faker::Lorem.characters(6) }
    end
end