# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search do
    query "MyString"
    searched_at "2014-03-06 12:44:20"
    converted_at "2014-03-06 12:44:20"
    product_id 1
  end
end
