# == Schema Information
#
# Table name: order_item_accessories
#
#  id            :integer          not null, primary key
#  order_item_id :integer
#  price         :decimal(10, )
#  quantity      :integer
#  accessory_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :order_item_accessory do
    sequence(:price) { |n| n }
    sequence(:quantity) { |n| n }
    
    association :accessory
    association :order_item
  end
end
