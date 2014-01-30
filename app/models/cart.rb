# Cart Documentation
#
# The cart table is designed as a session stored container (current_cart) for all the current user's cart item. 
# This is destroyed if abandoned for more than a day or the associated order has been completed.

# == Schema Information
#
# Table name: carts
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Cart < ActiveRecord::Base

  has_many :cart_items,       :dependent => :delete_all
  
  has_many :skus,             :through => :cart_items

  def add_cart_item(sku_id, sku_weight, sku_price, item_quantity, accessory_id)
    accessory_current_item = cart_items.where('sku_id = ?',sku_id).includes(:cart_item_accessory).where('cart_item_accessories.accessory_id = ?', accessory_id).first unless accessory_id.blank?
    # If it can find a SKU with the related accessory, it will assign the current_item. Otherwise it will just find the SKU normally.
  	current_item =  accessory_current_item ? accessory_current_item : cart_items.where('sku_id = ?', sku_id).first  
    accessory = Accessory.find(accessory_id) unless accessory_id.blank?
    # If the requested item has matching accessory requests, increase quantity. Otherwise, create new item.
    if (current_item && accessory_id.blank? && current_item.cart_item_accessory.nil?) || (current_item && !accessory_id.blank? && !current_item.cart_item_accessory.nil?)
  		current_item.quantity += item_quantity.to_i #if cart item selected exists, increment its quantity by 1
      current_item.weight += (sku_weight + current_item.cart_item_accessory.weight)
      # If accessory requested
      unless accessory_id.blank?
        current_item.cart_item_accessory.quantity += item_quantity.to_i
        current_item.weight += current_item.cart_item_accessory.weight
      end
    # Create new cart item with (possibly) new cart item accessory
  	else 
      unless accessory_id.blank?
        current_item = cart_items.build(:price => (sku_price + accessory.price), :sku_id => sku_id, :weight => (sku_weight + accessory.weight)) #if cart item selected does not exist, build a new cart item
        current_item.build_cart_item_accessory(:price => accessory.price, :accessory_id => accessory_id, :weight => accessory.weight)
      else
        current_item = cart_items.build(:price => sku_price, :sku_id => sku_id, :weight => sku_weight)
      end
      if item_quantity.to_i > 1
        current_item.quantity += (item_quantity.to_i-1)
        current_item.cart_item_accessory.quantity += (item_quantity.to_i-1) unless accessory_id.blank?
      end
  	end
  	current_item #return new item either by quantity or new cart item
  end

  def decrement_cart_item_quantity(cart_item_id)
    current_item = cart_items.find(cart_item_id)
    if current_item.quantity > 1
      current_item.quantity = current_item.cart_item_accessory.quantity -= 1
      # current_item.update_column(:weight, (current_item.weight - current_item.cart_item_accessory.weight)) 
    else
      current_item.destroy
    end
    current_item
  end

  def add_accessory_cart_item accessory_id
    accessory = Accessory.find(accessory_id)
    
  end

  def total_price 
  	cart_items.to_a.sum { |item| item.total_price }
  end
  
  private

  def self.clear_carts
    where("updated_at < ?", 12.hours.ago).destroy_all
  end
  
end
