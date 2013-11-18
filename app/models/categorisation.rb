class Categorisation < ActiveRecord::Base
  attr_accessible :category_id, :product_id
  belongs_to :product, :dependent => :destroy
  belongs_to :category, :dependent => :destroy
end
