FactoryGirl.define do
    factory :order do
        ip_address { Faker::Internet.ip_v4_address }
        email { Faker::Internet.email }
        state 'active'
        sequence(:tax_number) { |n| n }
        shipping_status
        shipping_date { Faker::Date.forwards(10) }
        sequence(:actual_shipping_cost) { |n| n }
        express_token { Faker::Lorem.characters(8) }
        express_payer_id { Faker::Lorem.characters(6) }
    end
end