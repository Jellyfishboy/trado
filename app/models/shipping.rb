class Shipping < ActiveRecord::Base
  attr_accessible :name, :price, :country_ids
  has_many :tiereds, :dependent => :delete_all
  has_many :tiers, :through => :tiereds
  has_many :destinations, :dependent => :delete_all
  has_many :countries, :through => :destinations
  validates :name, :price, :presence => true
  validates :name, :uniqueness => true, :length => {:minimum => 10, :message => :too_short}
  validates :price, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
end
