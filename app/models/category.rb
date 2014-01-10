class Category < ActiveRecord::Base
  attr_accessible :description, :name, :visible
  has_many :products
  validates :name, :description, :presence => true
  validates :name, :uniqueness => true
end
