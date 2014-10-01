# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title "MyString"
    content "MyText"
    page_title "MyString"
    meta_description "MyString"
    visible false
  end
end
