class Accessory < ActiveRecord::Base
  attr_accessible :name, :part_number, :sku_attributes
  has_many :accessorisations, :dependent => :delete_all
  has_one :sku, :dependent => :destroy
  has_many :orders, :through => :sku
  has_many :carts, :through => :sku
  validates :name, :part_number, :presence => true
  validates :name, :part_number, :uniqueness => true
  validates_numericality_of :part_number, :only_integer => true, :greater_than_or_equal_to => 1
  accepts_nested_attributes_for :sku
end
