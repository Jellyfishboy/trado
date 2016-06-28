# == Schema Information
#
# Table name: orders
#
#  id                   :integer          not null, primary key
#  email                :string
#  shipping_date        :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  actual_shipping_cost :decimal(8, 2)
#  delivery_id          :integer
#  ip_address           :string
#  user_id              :integer
#  net_amount           :decimal(8, 2)
#  gross_amount         :decimal(8, 2)
#  tax_amount           :decimal(8, 2)
#  terms                :boolean
#  cart_id              :integer
#  shipping_status      :integer          default(0)
#  consignment_number   :string
#  payment_type         :integer
#

FactoryGirl.define do
    factory :order do
        ip_address { Faker::Internet.ip_v4_address }
        email { Faker::Internet.email }
        shipping_status { 'pending' }
        shipping_date { "31/12/2014" }
        sequence(:actual_shipping_cost) { |n| n }
        # express_token { Faker::Lorem.characters(8) }
        # express_payer_id { Faker::Lorem.characters(6) }
        sequence(:net_amount) { |n| n }
        sequence(:tax_amount) { |n| n }
        sequence(:gross_amount) { |n| n }
        terms { true }
        consignment_number { '123456' }
        

        association :cart
        association :delivery, factory: :delivery_service_price
        
        transient do
            count 1
        end
        
        factory :pending_order do
            # has_many through relationship generation
            transactions { [create(:transaction, payment_status: 'pending')] }

            after(:create) do |order|
                create(:order_item, quantity: 5, order: order)
            end

            factory :addresses_pending_order do
                after(:create) do |order|
                    create(:address, addressable_type: 'OrderBillAddress', order: order)
                    create(:address, addressable_type: 'OrderShipAddress', order: order)
                end
            end
        end

        factory :ipn_order do
            transactions { [create(:transaction, payment_status: 'pending', gross_amount: '234.71')] }
            after(:create) do |order|
                create(:address, addressable_type: 'OrderBillAddress', order: order)
                create(:address, addressable_type: 'OrderShipAddress', order: order)
            end
        end

        factory :undispatched_complete_order do
            transactions { [create(:transaction)] }

            after(:create) do |order|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :complete_order do
            # has_many through relationship generation
            transactions { [create(:transaction)] }
            shipping_status { 'dispatched' }

            after(:create) do |order|
                create(:order_item, quantity: 5, order: order)
            end

            factory :addresses_complete_order do
                after(:create) do |order|
                    create(:address, addressable_type: 'OrderBillAddress', order: order)
                    create(:address, addressable_type: 'OrderShipAddress', order: order)
                end
            end
        end

        factory :paypal_order do
            transactions { [create(:transaction, payment_type: 'paypal')] }
            shipping_status { 'dispatched' }

            after(:create) do |order|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :failed_order do
            # has_many through relationship generation
            transactions { [create(:transaction, payment_status: 'failed')] }
            shipping_status { 'pending' }

            after(:create) do |order|
                create(:order_item, quantity: 5, order: order)
            end

            factory :addresses_failed_order do
                after(:create) do |order|
                    create(:address, addressable_type: 'OrderBillAddress', order: order)
                    create(:address, addressable_type: 'OrderShipAddress', order: order)
                end
            end
        end

        factory :fatal_failed_order do
            # has_many through relationship generation
            transactions { [create(:fatal_transaction, payment_status: 'failed')] }
            shipping_status { 'pending' }

            after(:create) do |order|
                create(:order_item, quantity: 5, order: order)
            end
        end

        factory :complete_accessory_order do
            # has_many through relationship generation
            transactions { [create(:transaction)] }
            shipping_status { 'dispatched' }

            after(:create) do |order|
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
            after(:create) do |order|
                create(:address, addressable_type: 'OrderBillAddress', order: order)
            end
        end

        factory :delivery_address_order do
            after(:create) do |order|
                create(:address, addressable_type: 'OrderShipAddress', order: order)
            end
        end

        factory :addresses_order do
            after(:create) do |order|
                create(:address, addressable_type: 'OrderBillAddress', order: order)
                create(:address, addressable_type: 'OrderShipAddress', order: order)
            end
        end
    end
end
