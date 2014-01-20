FactoryGirl.define do
    factory :country do
        name { Faker::Address.country }

        factory :invalid_country do
            name nil
        end
    end
end