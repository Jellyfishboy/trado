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

require 'rails_helper'

describe Transaction do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:order) }
end
