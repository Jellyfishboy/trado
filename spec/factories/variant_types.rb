# == Schema Information
#
# Table name: variant_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
    factory :variant_type do
        name { Faker::Lorem.characters(5) }
    end
end
