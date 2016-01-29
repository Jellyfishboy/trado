FactoryGirl.define do
    factory :user do
        email { Faker::Internet.email }
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        password { Faker::Lorem.characters(8) }
        password_confirmation { "#{password}" }
        remember_me false

        factory :standard_user do
            roles { [create(:role)] }
        end

        factory :admin do
            roles { [create(:role, name: 'admin')] }

            factory :attached_admin do
                after(:create) do |user|
                    create(:user_attachment, attachable: user)
                end
            end
        end
    end
end