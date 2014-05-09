FactoryGirl.define do
    factory :order do
        ip_address { Faker::Internet.ip_v4_address }
        email { Faker::Internet.email }
        status { 'active' }
        sequence(:tax_number) { |n| n }
        shipping_status { 'Pending' }
        shipping_date { Date.new(2014, 1, 29) }
        sequence(:actual_shipping_cost) { |n| n }
        express_token { Faker::Lorem.characters(8) }
        express_payer_id { Faker::Lorem.characters(6) }

        association :shipping
        association :ship_address, factory: :address
        association :bill_address, factory: :address

        ignore do
            count 1
        end

        factory :complete_order do
            after(:create) do |order, evaluator|
                create(:order_item, quantity: 5, order: order)
            end
        end
    end
end