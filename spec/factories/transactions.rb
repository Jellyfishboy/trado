# == Schema Information
#
# Table name: transactions
#
#  id               :integer          not null, primary key
#  transaction_type :string
#  payment_type     :string
#  fee              :decimal(8, 2)
#  order_id         :integer
#  gross_amount     :decimal(8, 2)
#  tax_amount       :decimal(8, 2)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  net_amount       :decimal(8, 2)
#  status_reason    :string
#  payment_status   :integer          default(0)
#  error_code       :integer
#

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
