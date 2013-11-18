class Tag < ActiveRecord::Base
  attr_accessible :name
  has_many :taggings, :dependent => :delete_all
  has_many :products, :through => :taggings
end
