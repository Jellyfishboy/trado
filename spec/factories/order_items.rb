# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  price      :decimal(8, 2)
#  quantity   :integer
#  sku_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer
#  weight     :decimal(8, 2)
#

FactoryGirl.define do
    factory :order_item do
        sequence(:price) { |n| n }
        sequence(:quantity) { |n| n }
        sequence(:weight) { |n| n }

        association :sku
        association :order

        factory :accessory_order_item do
            after(:create) do |order_item|
                create(:order_item_accessory, order_item: order_item)
            end
        end
    end
end
