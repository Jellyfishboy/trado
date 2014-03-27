FactoryGirl.define do
    factory :country do
        name { Faker::Address.country }
        iso { Faker::Lorem.characters(2) }
        available { false }
        language { Faker::Lorem.word }

        factory :invalid_country do
            name nil
        end

    end
end