# == Schema Information
#
# Table name: accessorisations
#
#  id           :integer          not null, primary key
#  accessory_id :integer
#  product_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :accessorisation do
    
    association :product
    association :accessory
  end
end
