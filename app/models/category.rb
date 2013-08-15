class Category < ActiveRecord::Base
  attr_accessible :description, :name, :product_id
end
