FactoryGirl.define do
    factory :user do
        email { Faker::Internet.email }
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        password { Faker::Lorem.characters(8) }
        password_confirmation { "#{password}" }
        remember_me false
        role 'user'

        factory :admin do
            role 'admin'
        end
    end
end