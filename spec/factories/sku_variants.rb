# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sku_variant do
    sku_id 1
    variant_type_id "MyString"
    integer "MyString"
    name "MyString"
  end
end
