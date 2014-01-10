class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :price, :quantity, :sku_id, :weight
  belongs_to :sku 
  belongs_to :cart
  
  def total_price 
  	price * quantity
  end


end
