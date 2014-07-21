require 'rails_helper'

describe OrdersController do

    store_setting

    describe 'GET #new' do

        context "if the current cart is empty" do
            let!(:cart) { create(:cart) }

            it "should flash a notice message" do
                get :new
                expect(subject.request.flash[:notice]).to_not be_nil
            end

            it "should redirect to the store front" do
                get :new
                expect(response).to redirect_to(root_url)
            end
            
        end

        context "if the current cart is not empty" do
            let!(:cart) { create(:cart_order) }
            before(:each) do
                controller.stub(:current_cart).and_return(cart)
            end

            context "if the current cart has no associated order" do
                let!(:cart) { create(:full_cart) }
                before(:each) do
                    controller.stub(:current_cart).and_return(cart)
                end

                it "should create a new order" do
                    expect{
                        get :new
                    }.to change(Order, :count).by(1)
                end

                it "should assign the new order to @order" do
                    get :new
                    cart.reload
                    expect(assigns(:order)).to eq cart.order
                end
            end

            context "if the current cart has an associated order" do
                let!(:cart) { create(:cart_order) }
                before(:each) do
                    controller.stub(:current_cart).and_return(cart)
                end

                it "should assign the current cart order to @order" do
                    get :new
                    expect(assigns(:order)).to eq cart.order
                end
            end

            it "should redirect to the review order" do
                get :new
                expect(response).to redirect_to(order_build_url(order_id: cart.order.id, id: 'review'))
            end
        end
    end
end