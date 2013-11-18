class Accessorisation < ActiveRecord::Base
  attr_accessible :product_id, :accessory_id
  belongs_to :product, :dependent => :destroy
  belongs_to :accessory, :dependent => :destroy
end
