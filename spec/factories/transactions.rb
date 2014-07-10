FactoryGirl.define do
    factory :transaction do
        sequence(:fee) { |n| n }
        sequence(:gross_amount) { |n| n }
        payment_status 'Completed'
        payment_type { Faker::Lorem.word }
        sequence(:tax_amount) { |n| n }
        paypal_id { Faker::Lorem.characters(8) }
        transaction_type { Faker::Lorem.word }
        sequence(:net_amount) { |n| n }
        status_reason 'none'
        
    end
end