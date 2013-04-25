class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  attr_accessible :address, :email, :name, :pay_type
  validates :name, :address, :email, :pay_type, :presence => true
  validates_each :pay_type do |model, attr, value|
  if !PayType.names.include?(value)
    model.errors.add(attr, "Payment type not on the list") 
  end #validates all columms from the paytype db have been collected
end

  def add_line_items_from_cart(cart)
  	cart.line_items.each do |item|
  		item.cart_id = nil
  		line_items << item
  	end
  end
end
