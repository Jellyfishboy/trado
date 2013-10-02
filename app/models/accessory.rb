class Accessory < ActiveRecord::Base
  attr_accessible :name, :price, :part_number
  has_many :accessorisations, :dependent => :destroy
  has_many :products, :through => :accessorisations
end
