# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :zonification do
    association :zone
    association :country
  end
end
