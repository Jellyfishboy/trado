# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_item_accessory do
    order_item_id 1
    price "9.99"
    quantity 1
    accessory_id 1
  end
end
