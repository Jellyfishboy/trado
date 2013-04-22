class CombineItemsInCart < ActiveRecord::Migration
  def self.up
  	#replace multiple items for a single product in a cart with a single item
  	Cart.all.each do |cart| #iterate over each cart
  		#count the number of each product in the cart, grouped by product id and grabbing their total quantity
  		sums = cart.line_items.group(:product_id).sum(:quantity)

  		sums.each do |product_id, quantity| #iterate over sums, extracting the product_id and quantity from each
  			#if item count by product_id is more than 1
  			if quantity > 1
  				#remove individual items
  				cart.line_items.where(:product_id=>product_id).delete_all

  				#replace with a single item
  				cart.line_items.where(:product_id=>product_id, :quantity=>quantity)
  			end
  		end
  	end
  end
  def self.down 
  	#split items with quantity>1 into multiple items
  	LineItem.where("quantity>1").each do |line_item|
  		#add individual items
  		line_item.quantity.times do
  			#use the extracted product id and cart id to create the items
  			LineItem.create :cart_id=>line_item.cart_id,:product_id=>line_item.product_id, :quantity=>1
  		end
  		#remove original item
	  	line_item.destroy
  	end	
  end
end
