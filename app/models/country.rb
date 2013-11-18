class Country < ActiveRecord::Base
  attr_accessible :name
  has_many :destinations, :dependent => :delete_all
  has_many :shippings, :through => :destinations
  validates :name, :uniqueness => true, :presence => true
end
