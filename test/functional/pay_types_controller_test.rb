require 'test_helper'

class PayTypesControllerTest < ActionController::TestCase
  setup do
    @pay_type = pay_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pay_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pay_type" do
    assert_difference('PayType.count') do
      post :create, pay_type: { name: @pay_type.name }
    end

    assert_redirected_to pay_type_path(assigns(:pay_type))
  end

  test "should show pay_type" do
    get :show, id: @pay_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pay_type
    assert_response :success
  end

  test "should update pay_type" do
    put :update, id: @pay_type, pay_type: { name: @pay_type.name }
    assert_redirected_to pay_type_path(assigns(:pay_type))
  end

  test "should destroy pay_type" do
    assert_difference('PayType.count', -1) do
      delete :destroy, id: @pay_type
    end

    assert_redirected_to pay_types_path
  end
end
