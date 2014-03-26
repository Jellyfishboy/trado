FactoryGirl.define do
  factory :tax_rate do
    name { Faker::Lorem.characters(10) }
    sequence(:rate) { |n| n } 

    factory :invalid_tax_rate do
        name nil
    end
  end
end
