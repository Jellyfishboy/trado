class LineItem < ActiveRecord::Base
  attr_accessible :cart_id, :product_id, :price, :weight, :thickness, :length, :sku, :quantity, :sku_id, :attribute_value, :attribute_type, :attribute_measurement
  belongs_to :product #the parent of lineitems is product
  belongs_to :cart #the parent of lineitems is cart
  belongs_to :order
  
  def total_price 
  	price * quantity
  end


end
