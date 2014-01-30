# CartItem Documentation
#
# The cart item table represents each item in the current cart. 
# These are transferred to order_items and deleted once the associated order has been completed.

# == Schema Information
#
# Table name: cart_items
#
#  id             :integer          not null, primary key
#  cart_id        :integer          
#  price          :decimal          precision(8), scale(2)
#  quantity       :integer          
#  sku_id         :integer    
#  weight         :decimal          precision(8), scale(2)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class CartItem < ActiveRecord::Base

  attr_accessible :cart_id, :price, :quantity, :sku_id, :weight, :cart_item_accessory_attributes

  has_one :cart_item_accessory,             :dependent => :destroy
  belongs_to :cart
  belongs_to :sku 

  accepts_nested_attributes_for :cart_item_accessory

  def total_price 
  	price * quantity
  end

  def update_quantity quantity, accessory
    self.quantity = quantity
    self.cart_item_accessory.quantity = quantity unless accessory.blank?
  end

  def update_weight quantity, weight
    self.weight = (weight*quantity)
  end

end
