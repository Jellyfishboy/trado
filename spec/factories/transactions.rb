FactoryGirl.define do
    factory :transaction do
        fee { |n| n }
        gross_amount { |n| n }
        payment_status 'Completed'
        payment_type { Faker::Lorem.word }
        tax_amount { |n| n }
        transaction_id { Faker::Lorem.characters(8) }
        transaction_type { Faker::Lorem.word }
        net_amount { |n| n }
        status_reason 'none'

        association :order
    end
end