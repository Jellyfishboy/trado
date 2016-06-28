# == Schema Information
#
# Table name: stock_adjustments
#
#  id          :integer          not null, primary key
#  description :string
#  adjustment  :integer          default(1)
#  sku_id      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  stock_total :integer
#

FactoryGirl.define do
    factory :stock_adjustment do
        description { Faker::Lorem.word }
        adjustment { 5 }
        stock_total { 5 }

    end
end
