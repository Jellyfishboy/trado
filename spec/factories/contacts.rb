FactoryGirl.define do
    factory :contact do
        name { Faker::Lorem.word }
        email { Faker::Internet.email }
        website { Faker::Internet.url }
        message { Faker::Lorem.paragraphs(2) }

        factory :invalid_contact do
            email { nil }
        end
    end
end