FactoryGirl.define do
  factory :order_item_accessory do
    sequence(:price) { |n| n }
    sequence(:quantity) { |n| n }
    
    association :accessory
    association :order_item
  end
end
