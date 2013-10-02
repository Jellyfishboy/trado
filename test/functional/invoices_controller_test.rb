require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: { billing_address: @invoice.billing_address, date: @invoice.date, delivery_address: @invoice.delivery_address, discount_amount: @invoice.discount_amount, discount_type: @invoice.discount_type, email: @invoice.email, first_name: @invoice.first_name, invoice_number: @invoice.invoice_number, last_name: @invoice.last_name, notes: @invoice.notes, order_number: @invoice.order_number, pay_type: @invoice.pay_type, shipping: @invoice.shipping }
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    get :show, id: @invoice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice
    assert_response :success
  end

  test "should update invoice" do
    put :update, id: @invoice, invoice: { billing_address: @invoice.billing_address, date: @invoice.date, delivery_address: @invoice.delivery_address, discount_amount: @invoice.discount_amount, discount_type: @invoice.discount_type, email: @invoice.email, first_name: @invoice.first_name, invoice_number: @invoice.invoice_number, last_name: @invoice.last_name, notes: @invoice.notes, order_number: @invoice.order_number, pay_type: @invoice.pay_type, shipping: @invoice.shipping }
    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to invoices_path
  end
end
