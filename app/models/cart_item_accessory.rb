# CartItemAccessory Documentation
#
# The cart item accessory table represents an accessory associated with a cart item. 
# These are transferred to order_item_accessories and deleted once the associated order has been completed.
# == Schema Information
#
# Table name: cart_item_accessories
#
#  id           :integer          not null, primary key
#  cart_item_id :integer
#  price        :decimal(8, 2)
#  quantity     :integer          default(1)
#  accessory_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CartItemAccessory < ActiveRecord::Base

  attr_accessible :cart_item_id, :price, :quantity, :accessory_id

  belongs_to :cart_item
  belongs_to :accessory 

end
