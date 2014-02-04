# OrderItemAccessory Documentation
#
# The order item accessory table represents an accessory associated with a order item. 
# They reference further data from the accessory table and are persisted for as long as the order, and it's order items, are associated with is present..

# == Schema Information
#
# Table name: cart_item_accessories
#
#  id                   :integer          not null, primary key
#  cart_item_id         :integer          
#  price                :decimal          precision(8), scale(2)
#  quantity             :integer          
#  accessory_id         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class OrderItemAccessory < ActiveRecord::Base

  attr_accessible :accessory_id, :order_item_id, :price, :quantity

  belongs_to :order_item
  belongs_to :accessory

end
