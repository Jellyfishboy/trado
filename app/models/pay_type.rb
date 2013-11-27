class PayType < ActiveRecord::Base
  attr_accessible :name, :description
  validates :name, :description, :presence => true
  validates :name, :uniqueness => true
  validates :description, :length => { :maximum => 100, :message => :too_long }
  has_many :payments
  has_many :orders, :through => :payments
end
