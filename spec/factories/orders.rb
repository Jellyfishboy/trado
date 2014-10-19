FactoryGirl.define do
    factory :order do
        ip_address { Faker::Internet.ip_v4_address }
        email { Faker::Internet.email }
        sequence(:tax_number) { |n| n }
        shipping_status { 'pending' }
        shipping_date { Date.new(2014, 1, 29) }
        sequence(:actual_shipping_cost) { |n| n }
        express_token { Faker::Lorem.characters(8) }
        express_payer_id { Faker::Lorem.characters(6) }
        net_amount { |n| n }
        tax_amount { |n| n }
        gross_amount { |n| n }
        terms { true }
        

        association :cart
        association :delivery, factory: :delivery_service_price
        
        ignore do
            count 1
        end
        
        factory :pending_order do
            # has_many through relationship generation
            transactions { [create(:transaction, payment_status: 'pending')] }

            after(:create) do |order, evaluator|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :ipn_order do
            transactions { [create(:transaction, payment_status: 'pending', gross_amount: '234.71')] }
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
            shipping_status { 'dispatched' }

            after(:create) do |order, evaluator|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :failed_order do
            # has_many through relationship generation
            transactions { [create(:transaction, payment_status: 'failed')] }
            shipping_status { 'pending' }

            after(:create) do |order, evaluator|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :complete_accessory_order do
            # has_many through relationship generation
            transactions { [create(:transaction)] }
            shipping_status { 'dispatched' }

            after(:create) do |order, evaluator|
                create(:accessory_order_item, quantity: 5, order: order)
            end
        end

        factory :edit_dispatch_order do
            transactions { [create(:transaction)] }
            actual_shipping_cost { nil }
            shipping_date { nil }
        end

        factory :cheque_order do
            transactions { [create(:transaction, payment_status: 'pending', payment_type: 'Cheque')] }
        end

        factory :bank_transfer_order do
            transactions { [create(:transaction, payment_status: 'pending', payment_type: 'Bank transfer')] }
        end

        factory :billing_address_order do
            after(:create) do |order, evaluator|
                create(:address, addressable_type: 'OrderBillAddress', order: order)
            end
        end

        factory :delivery_address_order do
            after(:create) do |order, evaluator|
                create(:address, addressable_type: 'OrderShipAddress', order: order)
            end
        end
    end
end