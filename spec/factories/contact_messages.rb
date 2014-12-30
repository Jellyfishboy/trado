FactoryGirl.define do
    factory :contact_message do
        name { Faker::Lorem.word }
        email { Faker::Internet.email }
        message { Faker::Lorem.paragraph(2) }

        factory :invalid_contact_message do
            email { nil }
        end
    end
end