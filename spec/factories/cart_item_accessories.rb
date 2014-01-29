# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_item_accessory do
    cart_item_id 1
    price "9.99"
    quantity 1
    accessory_id 1
    weight "9.99"
  end
end
