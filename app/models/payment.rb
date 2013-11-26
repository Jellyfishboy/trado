class Payment < ActiveRecord::Base
  attr_accessible :order_id, :pay_type_id
  belongs_to :pay_type
  belongs_to :order
end
