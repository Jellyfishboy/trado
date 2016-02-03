require 'rails_helper'

describe OrdersController do

    store_setting

    describe 'GET #confirm' do
        let!(:order) { create(:addresses_order, express_token: nil, express_payer_id: nil) }
        before(:each) do
            session[:payment_type] = 'express-checkout'
        end

        it "should assign the order record to @order" do
            get :confirm, id: order.id
            expect(assigns(:order)).to eq order
        end

        it "should assign the order's delivery address to @delivery_address" do
            get :confirm, id: order.id, token: 'abc1', PayerID: '2345'
            expect(assigns(:delivery_address)).to eq order.delivery_address
        end

        it "should assign the order's billing address to @billing_address" do
            get :confirm, id: order.id, token: 'abc1', PayerID: '2345'
            expect(assigns(:billing_address)).to eq order.billing_address
        end

        it "should render the confirm template" do
            get :confirm, id: order.id, token: 'abc1', PayerID: '2345'
            expect(response).to render_template :confirm
        end

        it "should update order's express_token attribute" do
            expect{
                get :confirm, id: order.id, token: 'abc1', PayerID: '2345'
            }.to change{
                order.reload
                order.express_token
            }.from(nil).to('abc1')
        end

        it "should update order's express_payer_id attribute" do
            expect{
                get :confirm, id: order.id, token: 'abc1', PayerID: '2345'
            }.to change{
                order.reload
                order.express_payer_id
            }.from(nil).to('2345')
        end

        context "if the payment_type attribute in the session store is nil" do
            before(:each) do
                session[:payment_type] = nil
            end

            it "should redirect to carts#checkout" do
                get :confirm, id: order.id, token: 'abc1', PayerID: '2345'
                expect(response).to redirect_to checkout_carts_url
            end
        end

        context "if token parameter is nil" do

            it "should redirect to carts#checkout" do
                get :confirm, id: order.id, PayerID: '2345'
                expect(response).to redirect_to checkout_carts_url
            end

            it "should render an error flash message" do
                get :confirm, id: order.id, PayerID: '2345'
                expect(subject.request.flash[:error]).to eq ['An error ocurred when trying to complete your order. Please try again.']
            end
        end

        context "if PayerID parameter is nil" do

            it "should redirect to carts#checkout" do
                get :confirm, id: order.id, token: 'abc1'
                expect(response).to redirect_to checkout_carts_url
            end

            it "should render an error flash message" do
                get :confirm, id: order.id, token: 'abc1'
                expect(subject.request.flash[:error]).to eq ['An error ocurred when trying to complete your order. Please try again.']
            end
        end
    end

    describe 'POST #complete' do
        let!(:cart) { create(:full_cart) }
        let!(:order) { create(:order, cart_id: cart.id) }
        before(:each) do
            stub_current_cart(cart)
            Store.PayProvider.any_instance.stub(complete: '/')
        end

        it "should assign the order record to @order" do
            post :complete, id: order.id
            expect(assigns(:order)).to eq order
        end

        it "should transfer all cart items over to order items" do
            expect{
                post :complete, id: order.id
            }.to change(OrderItem, :count).by(4)
        end

        it "should transfer all cart item accessories over to order item accessories" do
            expect{
                post :complete, id: order.id
            }.to change(OrderItemAccessory, :count).by(3)
        end
    end

    describe 'GET #success' do
        let!(:order) { create(:pending_order) }

        it "should assign the order record to @order" do
            get :success, id: order.id
            expect(assigns(:order)).to eq order
        end

        context "if the order's last transaction was pending" do

            it "should render the success template" do
                get :success, id: order.id
                expect(response).to render_template :success
            end
        end

        context "if the order's last transaction was successful" do
            let!(:order) { create(:complete_order)}

            it "should render the success template" do
                get :success, id: order.id
                expect(response).to render_template :success
            end
        end

        context "if the order's last transaction was a failure" do
            let!(:order) { create(:failed_order) }

            it "should redirect to store#home" do
                get :success, id: order.id
                expect(response).to redirect_to root_url
            end
        end
    end

    describe 'GET #failed' do
        let!(:order) { create(:failed_order) }

        it "should assign the order record to @order" do
            get :failed, id: order.id
            expect(assigns(:order)).to eq order
        end

        context "if the order's last transaction was successful" do
            let!(:order) { create(:complete_order) }

            it "should redirect to store#home" do
                get :failed, id: order.id
                expect(response).to redirect_to root_url
            end
        end

        context "if the order's last transaction was pending" do
            let!(:order) { create(:pending_order) }

            it "should redirect to store#home" do
                get :failed, id: order.id
                expect(response).to redirect_to root_url
            end
        end

        context "if the order's last transaction was a failure" do

            it "should render the failed template" do
                get :failed, id: order.id
                expect(response).to render_template :failed
            end
        end
    end

    describe 'GET #retry' do
        let!(:cart) { create(:cart) }
        let!(:order) { create(:fatal_failed_order, cart_id: nil) }
        before(:each) do
            stub_current_cart(cart)
        end

        it "should assign the last transaction record's error_code attribute value to @error_code" do
            get :retry, id: order.id
            expect(assigns(:error_code)).to eq order.transactions.last.error_code
        end

        context "if the last transaction has a fatal error code" do

            it "should not reassign the cart_id attribute for the order" do
                get :retry, id: order.id
                expect(order.cart_id).to eq nil
            end
        end

        context "if the last transaction does not have a fatal error code" do
            let!(:order) { create(:failed_order, cart_id: nil) }

            it "should reassign the cart_id attribute for the order" do
                expect{
                    get :retry, id: order.id
                }.to change{
                    order.reload
                    order.cart_id
                }.from(nil).to(cart.id)
            end
        end

        it "should redirect to carts#mycart" do
            get :retry, id: order.id
            expect(response).to redirect_to mycart_carts_url
        end
    end

    describe 'DELETE #destroy' do
        let!(:cart) { create(:cart) }
        let!(:order) { create(:order, cart_id: cart.id) }

        it "should assign the order record to @order" do
            delete :destroy, id: order.id
            expect(assigns(:order)).to eq order
        end

        it "should update the cart_id attribute for the order to nil" do
            expect{
                delete :destroy, id: order.id
            }.to change{
                order.reload
                order.cart_id
            }.from(cart.id).to(nil)
        end

        it "should redirect to the store#home" do
            delete :destroy, id: order.id
            expect(response).to redirect_to root_url
        end
    end
end