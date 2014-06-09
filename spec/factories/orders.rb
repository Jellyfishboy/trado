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
        net_amount { |n| n }
        tax_amount { |n| n }
        gross_amount { |n| n }
        terms { true }
        

        association :shipping
        association :ship_address, factory: :address
        association :bill_address, factory: :address

        ignore do
            count 1
        end
        
        factory :pending_order do
            # has_many through relationship generation
            transactions { [create(:transaction, payment_status: 'Pending')] }

            after(:create) do |order, evaluator|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :undispatched_complete_order do
            transactions { [create(:transaction)] }

            after(:create) do |order, evaluator|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :complete_order do
            # has_many through relationship generation
            transactions { [create(:transaction)] }
            shipping_status { 'Dispatched' }

            after(:create) do |order, evaluator|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :complete_accessory_order do
            # has_many through relationship generation
            transactions { [create(:transaction)] }
            shipping_status { 'Dispatched' }

            after(:create) do |order, evaluator|
                create(:accessory_order_item, quantity: 5, order: order)
            end
        end

        factory :nil_actual_shipping_order do
            transactions { [create(:transaction, payment_status: 'Pending')] }
            actual_shipping_cost { nil }
        end

        factory :nil_shipping_date_order do
            transactions { [create(:transaction)] }
            shipping_date { nil }
        end

        factory :cheque_order do
            transactions { [create(:transaction, payment_status: 'Pending', payment_type: 'Cheque')] }
        end

        factory :bank_transfer_order do
            transactions { [create(:transaction, payment_status: 'Pending', payment_type: 'Bank transfer')] }
        end
    end
end