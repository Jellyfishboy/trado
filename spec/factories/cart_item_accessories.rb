# == Schema Information
#
# Table name: cart_item_accessories
#
#  id           :integer          not null, primary key
#  cart_item_id :integer
#  price        :decimal(8, 2)
#  quantity     :integer          default(1)
#  accessory_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :cart_item_accessory do
    sequence(:price) { |n| n }
    sequence(:quantity) { |n| n }
    
    association :cart_item
    association :accessory
  end
end
