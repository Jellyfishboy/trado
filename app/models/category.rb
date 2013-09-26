class Category < ActiveRecord::Base
  attr_accessible :description, :name, :product_id
  has_many :categorisations
  has_many :products, :through => :categorisations

end
