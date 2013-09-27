class ProductOption < ActiveRecord::Base
  attr_accessible :name, :price
  has_many :accessorisations, :dependent => :destroy
  has_many :products, :through => :accessorisations
end
