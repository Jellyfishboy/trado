class Categorisation < ActiveRecord::Base
  attr_accessible :category_id, :product_id
  belongs_to :product
  belongs_to :category
end
