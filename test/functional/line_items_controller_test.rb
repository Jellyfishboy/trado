require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:o1_rails)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, :product_id => products(:ruby).id
    end

    assert_redirected_to store_path
  end

  test "should show line_item" do
    get :show, :id => @line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @line_item
    assert_response :success
  end

  test "should update line_item" do
    put :update, :id => @line_item, line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  # test "should decrease line item quantity" do
  #   assert_difference('LineItem.count') do
  #     delete :destroy, :id => @line_item
  # end

  #   assert_redirected_to store_path
  # end
  test "should create line_item via ajax" do
    assert_difference('LineItem.count') do
      xhr :post, :create, :product_id => products(:ruby).id # similar to the original create line_item on line 21, however it uses 'xhr :post' to stand for a AJAX request
    end

    assert_response :success
  end
end
