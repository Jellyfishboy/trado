require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products #indicates which fixture data to use 'products.yml'
  
  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:name].any?
  	assert product.errors[:description].any?
  	assert product.errors[:image_url].any?
  	assert product.errors[:price].any? #checks to see if any product attributes are empty
  end
  test "product price must be positive" do
  	product = Product.new(:name => products(:ruby).name,
  						  :description => products(:ruby).description,
  						  :image_url => products(:ruby).image_url) #creates a new product with the fixture data
  	assert product.invalid?
  	assert_equal "price must be greater than or equal to 0.01",
  		product.errors[:price].join('; ') #tests the price attribute with -1 and outputs error

  	assert product.invalid?
  	assert_equal "price must be greater than or equal to 0.01",
  		product.errors[:price].join('; ') #tests the price attrubute with 0 and outputs error

  	assert product.valid? #indicates price attribute is valid with 1
  end

  def new_product(image_url)
	  Product.new(:name => products(:ruby).name,
				  :description => products(:ruby).description,
				  :image_url => image_url,
				  :price => products(:ruby).price)
  end #method which creates a new product from the fixture data. image_url paramter is passed into it

  test "image url" do
  	ok = %w{tom.gif tom.png tom.jpg TOM.JPG Tom.Png} #hash of valid file types
  	bad = %w{tom.doc tom.aspx tom.png.more tom.gif.hello} #hash of invalid file types

  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} shouldn't be invalid"
  	end #loop to indicate file types within the ok hash are valid

  	bad.each do |name|
  		assert new_product(name).invalid?
  		assert_equal "invalid file type", "#{name} shouldn't be valid"
  	end #loop to indicate file types within the bad hash are invalid
  end 
  test "product is not valid without a unique name" do
  	product = Product.new(:name => products(:ruby).name,
  						  :description => products(:ruby).description,
  						  :price => products(:ruby).price,
  						  :image_url => products(:ruby).image_url) #create new product with fixture data
  	assert !product.save #fails to save
  	assert_equal "has already been taken", product.errors[:name].join('; ') #displays error due to duplicate product name

  end
end
