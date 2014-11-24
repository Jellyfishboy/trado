FactoryGirl.define do
    factory :stock_adjustment do
        description { Faker::Lorem.word }
        adjustment { 5 }
        stock_total { 5 }

    end
end
