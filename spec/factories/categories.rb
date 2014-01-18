FactoryGirl.define do
    factory :category do
        name { Faker::Lorem.word }
        description { Faker::Lorem.paragraph(1) }
        visible true
        slug { "#{name}" }
    end
end