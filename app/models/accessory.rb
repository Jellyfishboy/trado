class Accessory < ActiveRecord::Base
  attr_accessible :name, :price, :part_number
  has_many :accessorisations, :dependent => :delete_all
  has_many :products, :through => :accessorisations
  validates :name, :part_number, :price, :presence => true
  validates :name, :part_number, :uniqueness => true
  validates_numericality_of :part_number, :only_integer => true, :greater_than_or_equal_to => 1
  validates :price, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
end
