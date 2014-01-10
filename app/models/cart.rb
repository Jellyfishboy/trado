class Cart < ActiveRecord::Base
  has_many :cart_items, :dependent => :delete_all # A cart has many cart_items, however it is dependent on them. it will not be destroyed if a cart_item still exists within it

  def add_cart_item(sku_weight, sku_price, sku_id, item_quantity)
  	current_item = cart_items.where('sku_id = ?', sku_id).first #grabs all the products which match the product id
    if current_item
  		current_item.quantity += item_quantity.to_i #if cart item selected exists, increment its quantity by 1
      current_item.weight += sku_weight
  	else 
      current_item = cart_items.build(:price => sku_price, :sku_id => sku_id, :weight => sku_weight) #if cart item selected does not exist, build a new cart item
      if item_quantity.to_i > 1
        current_item.quantity += (item_quantity.to_i-1)
      end
  	end
  	current_item #return new item either by quantity or new cart item
  end
  def decrement_cart_item_quantity(cart_item_id)
    current_item = cart_items.find(cart_item_id)
    if current_item.quantity > 1
      current_item.quantity -= 1
    else
      current_item.destroy
    end
    current_item
  end

  def total_price 
  	cart_items.to_a.sum { |item| item.total_price }
  end

  def clear_carts
    Cart.where("updated_at < ?", 12.hours.ago).destroy_all
  end
end
