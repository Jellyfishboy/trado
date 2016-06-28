# == Schema Information
#
# Table name: delivery_service_prices
#
#  id                  :integer          not null, primary key
#  code                :string
#  price               :decimal(8, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  description         :text
#  active              :boolean          default(TRUE)
#  min_weight          :decimal(8, 2)
#  max_weight          :decimal(8, 2)
#  min_length          :decimal(8, 2)
#  max_length          :decimal(8, 2)
#  min_thickness       :decimal(8, 2)
#  max_thickness       :decimal(8, 2)
#  delivery_service_id :integer
#

FactoryGirl.define do
    factory :delivery_service_price do
        sequence(:code) { |n| "#{Faker::Lorem.word}#{n}" }
        sequence(:price) { |n| n }
        description { Faker::Lorem.characters(100) }
        sequence(:min_weight) { |n| n }
        sequence(:max_weight) { |n| n }
        sequence(:min_length) { |n| n }
        sequence(:max_length) { |n| n }
        sequence(:min_thickness) { |n| n }
        sequence(:max_thickness) { |n| n }
        active { false }

        association :delivery_service

        factory :invalid_delivery_service_price do
            code { nil }
        end
    end
end
