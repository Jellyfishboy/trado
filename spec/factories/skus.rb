# == Schema Information
#
# Table name: skus
#
#  id                  :integer          not null, primary key
#  price               :decimal(8, 2)
#  cost_value          :decimal(8, 2)
#  stock               :integer
#  stock_warning_level :integer
#  code                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_id          :integer
#  length              :decimal(8, 2)
#  weight              :decimal(8, 2)
#  thickness           :decimal(8, 2)
#  active              :boolean          default(TRUE)
#

FactoryGirl.define do
    factory :sku do
        sequence(:code) { |n| "5#{n}" }
        sequence(:cost_value) { |n| n }
        sequence(:price) { |n| n }
        stock { 30 }
        stock_warning_level { 5 }
        sequence(:length) { |n| n }
        sequence(:weight) { |n| n }
        sequence(:thickness) { |n| n }
        active { false }

        association :product

        factory :sku_in_stock do
            after(:create) do |sku|
                create(:sku_notification, notifiable: sku)
            end
        end

        factory :cart_item_sku do
            after(:create) do |sku|
                create(:cart_item, quantity: 5, sku: sku)
            end
        end

        factory :invalid_sku do
            code { nil }
        end
    end
end
