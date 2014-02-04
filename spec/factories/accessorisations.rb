FactoryGirl.define do
  factory :accessorisation do
    
    association :product
    association :accessory
  end
end
