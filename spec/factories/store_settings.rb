FactoryGirl.define do
    factory :store_setting do
        name { Faker::Lorem.word }
        email { Faker::Internet.email }
        currency { Faker::Lorem.characters(1) }
        tax_name { Faker::Lorem.word }

    end
end
