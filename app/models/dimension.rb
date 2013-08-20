class Dimension < ActiveRecord::Base
  attr_accessible :product_id, :size, :weight
  belongs_to :product
end
