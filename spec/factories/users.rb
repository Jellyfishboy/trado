# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string           default("Joe")
#  last_name              :string           default("Bloggs")
#

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
