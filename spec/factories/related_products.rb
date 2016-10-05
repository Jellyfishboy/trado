# == Schema Information
#
# Table name: related_products
#
#  product_id :integer
#  related_id :integer
#

FactoryGirl.define do
    factory :related_product do

        association :product
    end
end
