class ProductOption < ActiveRecord::Base
  attr_accessible :name, :price
  has_many :accessorisations
  has_many :products, :through => :accessorisations
end
