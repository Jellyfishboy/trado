class Dimensional < ActiveRecord::Base
  attr_accessible :dimension_id, :product_id
  belongs_to :dimension
  belongs_to :product
end
