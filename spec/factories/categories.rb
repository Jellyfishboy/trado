# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  active           :boolean          default(FALSE)
#  slug             :string
#  sorting          :integer          default(0)
#  page_title       :string
#  meta_description :string
#

FactoryGirl.define do
    factory :category do
        sequence(:name) { |n| "#{Faker::Lorem.characters(10)}#{n}" }
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
