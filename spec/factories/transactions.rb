FactoryGirl.define do
    factory :transaction do
        sequence(:fee) { |n| n }
        sequence(:gross_amount) { |n| n }
        payment_status { 'completed' }
        payment_type { Faker::Lorem.word }
        sequence(:tax_amount) { |n| n }
        # paypal_id { Faker::Lorem.characters(8) }
        transaction_type { Faker::Lorem.word }
        sequence(:net_amount) { |n| n }
        status_reason { 'none' }
        error_code { '0' }
        
        factory :fatal_transaction do
            error_code { '10415' }
        end
    end
end