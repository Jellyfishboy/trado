# Transaction Documentation
#
# The transaction table contains all the required information for either a successful or failed payment transaction for an order. 
# This allows the scalability of adding more payment methods to the application.

# == Schema Information
#
# Table name: transactions
#
#  id                           :integer          not null, primary key
#  order_id                     :integer      
#  net_amount                   :decimal          precision(8), scale(2)  
#  gross_amount                 :decimal          precision(8), scale(2)  
#  tax_amount                   :decimal          precision(8), scale(2)  
#  fee                          :decimal          precision(8), scale(2)  
#  payment_type                 :string(255)
#  payment_status               :string(255)   
#  paypal_id                    :string(255) 
#  transaction_type             :string(255)  
#  status_reason                :string(255)      
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
class Transaction < ActiveRecord::Base

  attr_accessible :fee, :gross_amount, :order_id, :payment_status, :payment_type, 
  :tax_amount, :paypal_id, :transaction_type, :net_amount, :status_reason
  
  belongs_to :order
end
