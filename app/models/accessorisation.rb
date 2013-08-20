class Accessorisation < ActiveRecord::Base
  attr_accessible :accessory_id, :product_option_id
  belongs_to :product
  belongs_to :product_option
end
