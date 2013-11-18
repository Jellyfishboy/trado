class Accessory < ActiveRecord::Base
  attr_accessible :name, :price, :part_number
  has_many :accessorisations, :dependent => :delete_all
  has_many :products, :through => :accessorisations
end
