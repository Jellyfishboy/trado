class LineItem < ActiveRecord::Base
  attr_accessible :cart_id, :product_id, :price, :weight, :thickness, :length, :dimension_id, :sku, :quantity
  validates :dimension_id, :presence => true
  belongs_to :product #the parent of lineitems is product
  belongs_to :cart #the parent of lineitems is cart
  belongs_to :order
  
  def total_price 
  	price * quantity
  end


end
