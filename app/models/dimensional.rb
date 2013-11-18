class Dimensional < ActiveRecord::Base
  attr_accessible :dimension_id, :product_id
  belongs_to :dimension, :dependent => :destroy
  belongs_to :product, :dependent => :destroy
end
