class LineItem < ActiveRecord::Base
  attr_accessible :cart_id, :product_id, :product_price
  belongs_to :product #the parent of lineitems is product
  belongs_to :cart #the parent of lineitems is cart

  def total_price 
  	product.price * quantity
  end
end
