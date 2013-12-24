class Category < ActiveRecord::Base
  attr_accessible :description, :name, :visible
  has_many :products
  validates :name, :uniqueness => true, :presence => true
end
