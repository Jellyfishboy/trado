require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :products, :carts, :line_items

  test "add unique products" do   	
  	cart = Cart.create #create new cart
  	cart.add_product(products(:rails).id, products(:rails).price).save! #creates new product with rails fixture data
  	cart.add_product(products(:ruby).id, products(:ruby).price).save! #creates new product with ruby fixture data
  	assert_equal 2, cart.line_items.count #line items count is expected to be 2
  	assert_equal products(:ruby).price + products(:rails).price, cart.total_price #the cart total price is expected to equal the addition of both the products
  end
  test "add duplicate products" do
  	cart = Cart.create
  	cart.add_product(products(:rails).id, products(:rails).price).save! 
  	cart.add_product(products(:rails).id, products(:rails).price).save! #create two products with rails fixture data
  	assert_equal 2*products(:rails).price, cart.total_price #the cart total price is expected to be the total of the rails product times 2
  	assert_equal 1, cart.line_items.count #line item count is expected to remain at 1
  	assert_equal 2, cart.line_items[0].quantity #selecting the first line item with an array value, then quantity of the line item is expected to be 2
  end

  test "empty cart should be destroyed" do
    cart = Cart.create
    cart.add_product(products(:rails).id, products(:rails).price).save! 
    assert_equal 1, cart.line_items[0].quantity
    cart.decrement_line_item_quantity(line_items(:o1_rails).id)
    assert_equal 0, cart.line_items[0].quantity
  end

end
