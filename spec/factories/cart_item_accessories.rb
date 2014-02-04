FactoryGirl.define do
  factory :cart_item_accessory do
    price { |n| n }
    quantity { |n| n }
    weight { |n| n }

    association :cart_item
    association :accessory
  end
end
