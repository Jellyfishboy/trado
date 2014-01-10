class OrderItem < ActiveRecord::Base
  attr_accessible :price, :quantity, :sku_id, :order_id, :weight
  belongs_to :sku
  belongs_to :order  
end
