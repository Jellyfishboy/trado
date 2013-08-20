class Shipping < ActiveRecord::Base
  has_many :dimensions
  has_many :product_dimensions, :through => :dimensions, :source => :products
  attr_accessible :description, :insurance, :name, :price
end
