class Category < ActiveRecord::Base
  has_many :products
  attr_accessible :description, :name, :product_id
  
end
