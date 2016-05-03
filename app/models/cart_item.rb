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

	has_one :cart_item_accessory,             	dependent: :delete
	belongs_to :cart
	belongs_to :sku 

	validates :cart_id, :price, :quantity, 
	:sku_id, :weight,							presence: true

	after_commit :reset_delivery_services

	accepts_nested_attributes_for :cart_item_accessory

	default_scope { order(created_at: :desc) }

	scope :find_sku,                           	->(sku) { where(sku_id: sku.id).includes(:cart_item_accessory) }
	scope :no_item_accessory,                  	-> { where(cart_item_accessories: { accessory_id: nil }) }
	scope :item_accessory,                     	-> (accessory) { where(cart_item_accessories: { accessory_id: accessory.id }) }

	# Calculates the total price of a cart item by multipling the item price by it's quantity
	#
	# @return [Decimal] total price of cart item
	def total_price 
		price * quantity
	end

	# Either creates or updates a cart item, including any assocated accessories
	#
	# @param sku [Object]
	# @param quantity [String]
	# @param accessory [String]
	# @paam cart [Object]
	# @return [Decimal] cart item
	def self.adjust sku, quantity, accessory, cart
		accessory = Accessory.find_by_id(accessory[:accessory_id]) unless accessory.nil?
		current_item = accessory.nil? ? cart.cart_items.find_sku(sku).no_item_accessory.first : cart.cart_items.find_sku(sku).item_accessory(accessory).first

		if current_item
			current_item.update_quantity((current_item.quantity+quantity.to_i), accessory)
			current_item.update_weight(current_item.quantity, sku.weight, accessory)
		else
			accessory_price = accessory.try(:price)
			accessory_price ||= 0
			current_item = cart.cart_items.build(price: (sku.price + accessory_price), sku_id: sku.id)
			current_item.build_cart_item_accessory(price: accessory.price, accessory_id: accessory.id) unless accessory.nil?
			current_item.update_quantity(quantity.to_i, accessory)
			current_item.update_weight(quantity, sku.weight, accessory)
		end
		current_item.quantity.zero? ? current_item.destroy : current_item.save
		current_item unless current_item.nil?
	end

	# Updates the quantity of a cart item, taking into account associated accessories
	#
	# @return [Object] current cart item
	def update_quantity quantity, accessory
		self.quantity = quantity
		self.cart_item_accessory.quantity = quantity unless accessory.nil?
	end

	# Updates the weight of a cart item, taking into account associated accessories
	#
	# @return [Object] current cart item
	def update_weight quantity, weight, accessory
		weight = accessory.nil? ? weight : (weight + accessory.weight)
		self.weight = (weight*quantity.to_i)
	end

	def reset_delivery_services
		cart.delivery_id = cart.country = nil
		cart.delivery_service_ids = cart.calculate_delivery_services(Store.tax_rate)
		cart.save!
	end
end
