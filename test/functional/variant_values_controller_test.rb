require 'test_helper'

class VariantValuesControllerTest < ActionController::TestCase
  setup do
    @variant_value = variant_values(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variant_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variant_value" do
    assert_difference('VariantValue.count') do
      post :create, variant_value: { sku_id: @variant_value.sku_id, value: @variant_value.value, variant_id: @variant_value.variant_id }
    end

    assert_redirected_to variant_value_path(assigns(:variant_value))
  end

  test "should show variant_value" do
    get :show, id: @variant_value
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @variant_value
    assert_response :success
  end

  test "should update variant_value" do
    put :update, id: @variant_value, variant_value: { sku_id: @variant_value.sku_id, value: @variant_value.value, variant_id: @variant_value.variant_id }
    assert_redirected_to variant_value_path(assigns(:variant_value))
  end

  test "should destroy variant_value" do
    assert_difference('VariantValue.count', -1) do
      delete :destroy, id: @variant_value
    end

    assert_redirected_to variant_values_path
  end
end
