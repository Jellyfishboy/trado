FactoryGirl.define do
    factory :category do
        name { |n| "#{Faker::Lorem.characters(10)}#{n}" }
        description { Faker::Lorem.paragraph(1) }
        active { true }
        sorting { Faker::Number.digit }
        page_title { Faker::Lorem.characters(20) }
        meta_description { Faker::Lorem.characters(100) }

        factory :invalid_category do
            name nil
        end
    end
end