class Country < ActiveRecord::Base
  attr_accessible :name
  has_many :destinations
  has_many :shippings, :through => :destinations
end
