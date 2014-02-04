FactoryGirl.define do
  factory :order_item_accessory do
    price { |n| n }
    quantity { |n| n }
    
    association :accessory
    association :order_item
  end
end
