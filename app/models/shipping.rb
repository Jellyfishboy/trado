class Shipping < ActiveRecord::Base
  attr_accessible :name, :price, :country_ids
  has_many :tiereds
  has_many :tiers, :through => :tiereds
  has_many :destinations
  has_many :countries, :through => :destinations
end
