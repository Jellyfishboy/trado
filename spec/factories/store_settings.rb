# == Schema Information
#
# Table name: store_settings
#
#  id            :integer          not null, primary key
#  name          :string           default("Trado")
#  email         :string           default("admin@example.com")
#  currency      :string           default("£")
#  tax_name      :string           default("VAT")
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ga_code       :string           default("UA-XXXXX-X")
#  ga_active     :boolean          default(FALSE)
#  tax_rate      :decimal(8, 2)    default(20.0)
#  tax_breakdown :boolean          default(FALSE)
#  theme_name    :string           default("redlight")
#

FactoryGirl.define do
    factory :store_setting do
        name { Faker::Lorem.word }
        email { Faker::Internet.email }
        currency { '£' }
        tax_name { Faker::Lorem.word }
        tax_rate { '20.0' }
        tax_breakdown { false }
        ga_code { Faker::Lorem.characters(8) }
        ga_active { true }
        theme_name { 'redlight' }

        factory :attached_store_setting do
            after(:create) do |store_setting|
                create(:store_setting_attachment, attachable: store_setting)
            end
        end
    end
end
