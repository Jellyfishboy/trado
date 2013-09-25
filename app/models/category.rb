class Category < ActiveRecord::Base
  has_many :categorisations
  has_many :products, :through => :categorisations
  attr_accessible :description, :name, :product_id

end
