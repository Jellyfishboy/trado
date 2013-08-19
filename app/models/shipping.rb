class Shipping < ActiveRecord::Base
  has_many :dimensions
  has_many :products, :through => :dimensions
  attr_accessible :description, :insurance, :name, :price
end
