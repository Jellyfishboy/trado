require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @update = {
      :name => 'Lorem Ipsum',
      :description => 'About Lorem Ipsum and how it landed in the internet',
      :image_url => 'lorem.jpg',
      :price => '20.25'
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
    assert_select "#main #product_list table tr", :minimum => 3 #attempts to select the css selector chain of elements at least 3 times
    assert_select "h1", "Listing products" #attempts to select a h1 tag with the text containing "Listing products"
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, :product => @update
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, :id => @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @product
    assert_response :success
  end

  test "should update product" do
    put :update, :id => @product.to_param, :product => @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => @product
    end

    assert_redirected_to products_path
  end
end
