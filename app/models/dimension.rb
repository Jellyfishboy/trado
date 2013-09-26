class Dimension < ActiveRecord::Base
  attr_accessible :size, :weight
  has_many :dimensionals
  has_many :products, :through => :dimensionals
end
