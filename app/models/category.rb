class Category < ActiveRecord::Base
  attr_accessible :description, :name, :visible
  has_many :categorisations
  has_many :products, :through => :categorisations

end
