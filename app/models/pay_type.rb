class PayType < ActiveRecord::Base
  attr_accessible :name
  has_many :payments
  has_many :orders, :through => :payments
end
