FactoryGirl.define do
    factory :stock_level do
        description { Faker::Lorem.word }
        adjustment { 5 }
        
        association :sku
    end
end
