FactoryGirl.define do
    factory :user do
        email { Faker::Internet.email }
        password { Faker::Lorem.characters(8) }
        password_confirmation { "#{password}" }
        remember_me false
    end
end