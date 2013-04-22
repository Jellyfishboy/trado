class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :line_items, :dependent => :destroy #a cart has many lineitems, however it is dependent on them. it will not be destroyed if a lineitem still exists within it

  def add_product(product_id, product_price)
  	current_item = line_items.find_by_product_id(product_id) #grabs current line item by the parameter passed in, product_id
  	if current_item
  		current_item.quantity += 1 #if line item selected exists, increment its quantity by 1
  	else 
  		current_item = line_items.build(:product_id => product_id, :price => product_price) #if line item selected does not exist, build a new cart item
  	end
  	current_item #return new item either by quantity or new cart item
  end
  def total_price 
  	line_items.to_a.sum { |item| item.total_price }
  end
end
