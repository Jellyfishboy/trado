class Transaction < ActiveRecord::Base
  attr_accessible :fee, :gross_amount, :order_id, :payment_status, :payment_type, :tax_amount, :transaction_id, :transaction_type, :net_amount
  belongs_to :order
end
