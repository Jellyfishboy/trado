require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products
  fixtures :orders

	LineItem.delete_all
	Order.delete_all
	ruby_book = products(:ruby)
  order_one = orders(:one)

	test "buying a product" do
		# verifys the intial landing page is index
		get "/"
		assert_response :success
		assert_template "index"

		# creates a new line item with post request via ajax
		xml_http_request :post, '/line_items', :product_id => ruby_book.id
		assert_response :success

		# creates new cart and confirms it has 1 line item. its first line item in the array contains the correct product
		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal ruby_book, cart.line_items[0].product

		# continues to generating a new order page
		get "/orders/new"
		assert_response :success
		assert_template "new"

		# generates post request and redirects to index template. then confirms the cart has 0 line items remaining
		post_via_redirect "/orders"
							:order => { :name 		=> "Tom Dallimore",
										:address 	=> "671 Wells Road",
										:email 		=> "tom.alan.dallimore@googlemail.com",
										:pay_type	=> "Check" }

		assert_response :success
		assert_template "index"
		cart = Cart.find(session[:cart_id])
		assert_equal 0, cart.line_items.size

		# check the database content matches the data passed in the post request. confirm the order count is 1, the order fields have the same values, the order line item count is 1 and the line item product object matches
		orders = Order.all
		assert_equal 1, orders.size
		order = orders[0]

		assert_equal "Tom Dallimore", 						order.name
		assert_equal "671 Wells Road",						order.address
		assert_equal "tom.alan.dallimore@googlemail.com",	order.email
		assert_equal "Check",								order.pay_type

		assert_equal 1, order.line_items.size
		line_item = order.line_items[0]
		assert_equal ruby_book, line_item.product

		# finally select the last deliery made by the action mailer, and confirm the to, from and subject fields match
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["tom.alan.dallimore@googlemail.com"], mail.to
		assert_equal "Tom Dallimore <tom.alan.dallimore@googlemail.com>", mail[:from].value
		assert_equal "Pragmatic Store Order Confirmation", mail.subject

  end

  test "send application error email when attempting order edit" do

    get "/orders/#{order_one.id}/edit"
    assert_response :fail

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["tom.alan.dallimore@googlemail.com"], mail.to
    assert_equal "Tom Dallimore <tom.alan.dallimore@googlemail.com>", mail[:from].value
    assert_equal "Application Error: Order"

    get "/"
    assert_response :redirect
    assert_template "index"

  end

  test "send shipping mail when ship date value confirmed" do

    get "/orders/#{order_one.id}/edit"
    assert_response :success
    assert_template "edit"

    post_via_redirect "/orders"
                      :order => { :name => "Tom Dallimore",
                                  :address => "MyText",
                                  :email => "MyString",
                                  :pay_type => "MyString",
                                  :ship_date => "2013-05-30 00:00:00 UTC"}
    order = Order.last

    assert_equal "Tom Dallimore", order.name
    assert_equal "MyText", order.address
    assert_equal "MyString", order.email
    assert_equal "MyString", order.pay_type
    assert_equal "2013-05-30 00:00:00 UTC", order.ship_date

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["MyString"], mail.to
    assert_equal "Tom Dallimore <tom.alan.dallimore@googlemail.com>", mail[:from].value
    assert_equal 'Pragmatic Store Order Shipped'

    assert_response :success
    assert_template "index"

  end
end