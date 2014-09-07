require 'rails_helper'

describe Admin::OrdersController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:order_1) { create(:order) }
        let!(:order_2) { create(:order) }

        it "should populate an array of all orders" do
            get :index
            expect(assigns(:orders)).to match_array([order_1, order_2])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #show' do
        let(:order) { create(:order) }

        it "should assign the requested order to @order" do
            get :show, id: order.id
            expect(assigns(:order)).to eq order
        end
    end

    describe 'GET #edit' do
        let!(:order) { create(:order) }

        it "should assign the requested order to @order" do
            xhr :get, :edit , id: order.id
            expect(assigns(:order)).to eq order
        end
        it "should render the edit partial" do
            xhr :get, :edit, id: order.id
            expect(response).to render_template(partial: 'admin/orders/_edit')
        end
    end

    describe 'PATCH #update' do
        let!(:order) { create(:order, actual_shipping_cost: '2.55') }

        it "should assign the requested order to @order" do
            xhr :patch, :update , id: order.id
            expect(assigns(:order)).to eq order
        end

        context "with valid attributes" do

            it "should update the order" do
                xhr :patch, :update, id: order.id, order: attributes_for(:order, actual_shipping_cost: '1.88')
                order.reload
                expect(order.actual_shipping_cost).to eq BigDecimal.new("1.88")
            end

            it "should render the success partial" do
                xhr :patch, :update, id: order.id, order: attributes_for(:order, actual_shipping_cost: '1.88')
                expect(response).to render_template(partial: 'admin/orders/_update')
            end
        end

        context "with invalid attributes" do

            it "should not update the order" do
                xhr :patch, :update, id: order.id, order: attributes_for(:order, actual_shipping_cost: nil)
                expect(order.actual_shipping_cost).to eq BigDecimal.new("2.55")
            end

            it "should return a JSON object of errors" do

            end
        end
    end
end