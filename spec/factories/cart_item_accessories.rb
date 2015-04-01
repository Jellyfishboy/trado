FactoryGirl.define do
  factory :cart_item_accessory do
    sequence(:price) { |n| n }
    sequence(:quantity) { |n| n }
    
    association :cart_item
    association :accessory
  end
end
