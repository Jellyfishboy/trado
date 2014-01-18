FactoryGirl.define do
    factory :notification do
        email { Faker::Internet.email }
        sent false
        sent_at nil

        factory :sent_notification do
            sent true
            sent_at { Faker::Date.backward(1) }
        end
        
        factory :sku_notification do
            association :notifiable, :factory => :sku
        end

        factory :user_notification do
            association :notifiable, :factory => :user
        end
    end
end