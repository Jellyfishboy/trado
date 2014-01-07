require 'test_helper'

class SkusControllerTest < ActionController::TestCase
  setup do
    @sku = skus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:skus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sku" do
    assert_difference('Sku.count') do
      post :create, sku: { cost_value: @sku.cost_value, price: @sku.price, sku: @sku.sku, stock: @sku.stock, stock_warning_level: @sku.stock_warning_level }
    end

    assert_redirected_to sku_path(assigns(:sku))
  end

  test "should show sku" do
    get :show, id: @sku
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sku
    assert_response :success
  end

  test "should update sku" do
    put :update, id: @sku, sku: { cost_value: @sku.cost_value, price: @sku.price, sku: @sku.sku, stock: @sku.stock, stock_warning_level: @sku.stock_warning_level }
    assert_redirected_to sku_path(assigns(:sku))
  end

  test "should destroy sku" do
    assert_difference('Sku.count', -1) do
      delete :destroy, id: @sku
    end

    assert_redirected_to skus_path
  end
end
