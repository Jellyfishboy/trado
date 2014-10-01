FactoryGirl.define do
    factory :page do
        title { Faker::Lorem.word }
        content { Faker::Lorem.paragraphs(3) }
        page_title { Faker::Lorem.sentence }
        meta_description { Faker::Lorem.sentence }
        visible { true }
    end
end
