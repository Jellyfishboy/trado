# == Schema Information
#
# Table name: sku_variants
#
#  id              :integer          not null, primary key
#  sku_id          :integer
#  variant_type_id :integer
#  name            :string
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do
    factory :sku_variant do
        name { Faker::Lorem.characters(5) }

        association :sku
        association :variant_type
    end
end
