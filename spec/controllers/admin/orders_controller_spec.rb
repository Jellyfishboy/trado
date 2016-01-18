require 'rails_helper'

describe Admin::OrdersController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:order_1) { create(:complete_order, created_at: 2.hours.ago) }
        let!(:order_2) { create(:complete_order, created_at: Time.now) }

        it "should populate an array of all orders" do
            get :index
            expect(assigns(:orders)).to match_array([order_2, order_1])
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
    end

    describe 'PUT #update' do
        let!(:order) { create(:complete_order, actual_shipping_cost: '2.55') }

        it "should assign the requested order to @order" do
            xhr :patch, :update , id: order.id, order: attributes_for(:order, actual_shipping_cost: '1.88')
            expect(assigns(:order)).to eq order
        end

        context "with valid attributes" do

            it "should update the order" do
                xhr :patch, :update, id: order.id, order: attributes_for(:order, actual_shipping_cost: '1.88')
                order.reload
                expect(order.actual_shipping_cost).to eq BigDecimal.new("1.88")
            end

            it "should send a new tracking email", broken: true do
                expect{
                    xhr :patch, :update, id: order.id, order: attributes_for(:order, consignment_number: '1111TT5566')
                }.to change {
                    ActionMailer::Base.deliveries.count
                }.by(1)
            end
        end

        context "with invalid attributes" do
            let!(:order) { create(:complete_order, actual_shipping_cost: '2.55') }
            let(:errors) { ["Actual shipping cost can't be blank"] }

            it "should not update the order" do
                xhr :patch, :update, id: order.id, order: attributes_for(:order, actual_shipping_cost: nil)
                expect(order.actual_shipping_cost).to eq BigDecimal.new("2.55")
            end

            it "should return a JSON object of errors" do
                xhr :patch, :update, id: order.id, order: attributes_for(:order, actual_shipping_cost: nil)
                expect(assigns(:order).errors.full_messages).to eq errors
            end

            it "should return a 422 status code" do
                xhr :patch, :update, id: order.id, order: attributes_for(:order, actual_shipping_cost: nil)
                expect(response.status).to eq 422
            end
        end
    end
end