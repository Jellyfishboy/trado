FactoryGirl.define do
    factory :stock_adjustment do
        description { Faker::Lorem.word }
        adjustment { 5 }
        
        association :sku
    end
end
