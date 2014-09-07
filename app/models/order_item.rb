# OrderItem Documentation
#
# The order item table represents each item within an order. 
# They reference further data from the SKU table and are persisted for as long as the order it's associated with is present. 

# == Schema Information
#
# Table name: order_items
#
#  id             :integer          not null, primary key
#  order_id        :integer          
#  price          :decimal          precision(8), scale(2)
#  quantity       :integer          default(1)
#  sku_id         :integer          
#  weight         :decimal          precision(8), scale(2)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class OrderItem < ActiveRecord::Base

  attr_accessible :price, :quantity, :sku_id, :order_id, :weight

  has_one :order_item_accessory,            dependent: :delete
  belongs_to :sku
  belongs_to :order  
  has_one :product,                         through: :sku

  # Calculates the total price of an order item by multipling the item price by it's quantity
  #
  # @return [Decimal] total price of cart item
  def total_price 
    price * quantity
  end

end
