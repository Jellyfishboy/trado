class Accessorisation < ActiveRecord::Base
  attr_accessible :product_id, :product_option_id
  belongs_to :product
  belongs_to :product_option
end
