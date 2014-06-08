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

  has_one :cart_item_accessory,             :dependent => :delete
  belongs_to :cart
  belongs_to :sku 

  accepts_nested_attributes_for :cart_item_accessory

  scope :find_sku, ->(sku) { where('sku_id = ?',sku.id).includes(:cart_item_accessory) }

  # Calculates the total price of a cart item by multipling the item price by it's quantity
  #
  # @return [Decimal] total price of cart item
  def total_price 
  	price * quantity
  end

  # Adds a new cart item or increases the quantity and weight of a cart item - including any assocated accessories
  #
  # @param sku [Object]
  # @param quantity [String]
  # @param accessory [String]
  # @paam cart [Object]
  # @return [Decimal] cart item
  def self.increment sku, quantity, accessory, cart
    accessory = Accessory.find(accessory[:accessory_id]) unless accessory.nil?
    current_item = accessory.blank? ? cart.cart_items.find_sku(sku).where(:cart_item_accessories => { :accessory_id => nil }).first : cart.cart_items.find_sku(sku).where(:cart_item_accessories => { :accessory_id => accessory.id }).first

    if (current_item && current_item.cart_item_accessory.nil?) || (current_item && !current_item.cart_item_accessory.nil?)
      current_item.update_quantity((current_item.quantity+quantity.to_i), accessory)
      current_item.update_weight(current_item.quantity, sku.weight, accessory)
    else 
      if accessory.blank?
        current_item = cart.cart_items.build(:price => sku.price, :sku_id => sku.id)
      else
        current_item = cart.cart_items.build(:price => (sku.price + accessory.price), :sku_id => sku.id)
        current_item.build_cart_item_accessory(:price => accessory.price, :accessory_id => accessory.id)
      end
      current_item.update_quantity(quantity.to_i, accessory)
      current_item.update_weight(quantity, sku.weight, accessory)
    end
    current_item
  end


  # Decreases the quantity and weight of a cart item, including any associated accessories
  #
  def decrement!  
    if quantity > 1
      self.update_quantity((quantity-1), cart_item_accessory)
      self.update_weight((quantity), sku.weight, cart_item_accessory ? cart_item_accessory.accessory : nil)
    else
      self.destroy
    end
  end

  # Updates the quantity of a cart item, taking into account associated accessories
  #
  # @return [Object] current cart item
  def update_quantity quantity, accessory
    self.quantity = quantity
    self.cart_item_accessory.quantity = quantity unless accessory.blank?
  end

  # Updates the weight of a cart item, taking into account associated accessories
  #
  # @return [Object] current cart item
  def update_weight quantity, weight, accessory
    weight = accessory.nil? ? weight : (weight + accessory.weight)
    self.weight = (weight*quantity.to_i)
  end
  
end
