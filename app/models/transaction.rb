# Transaction Documentation
#
# The transaction table contains all the required information for either a successful or failed payment transaction for an order. 
# This allows the scalability of adding more payment methods to the application.
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

class Transaction < ActiveRecord::Base
    attr_accessible :fee, :gross_amount, :order_id, :payment_status, :payment_type, 
    :tax_amount, :transaction_type, :net_amount, :status_reason, :error_code
  
    belongs_to :order

    enum payment_status: [:pending, :completed, :failed]
end
