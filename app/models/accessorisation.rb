class Accessorisation < ActiveRecord::Base
  attr_accessible :product_id, :accessory_id
  belongs_to :product
  belongs_to :accessory
end
