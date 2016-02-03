require 'rails_helper'

describe CartsController do

    store_setting

    describe 'GET #mycart' do

        it "should render the mycart template" do
            get :mycart
            expect(response).to render_template :mycart
        end
    end

    describe 'GET #checkout' do
        let!(:delivery_service_price) { create(:delivery_service_price) }
        let!(:cart) { create(:cart, estimate_delivery_id: delivery_service_price.id, estimate_country_name: 'United Kingdom') }
        before(:each) do
            stub_current_cart(cart)
        end

        it "should assign the calculated cart values to @cart_total" do
            get :checkout
            expect(assigns(:cart_total)).to eq cart.calculate(0.2)
        end

        context "if the order doesn't have an associated delivery address record" do

            it "should assign the cart estimate_country_name attribute value to @country" do
                get :checkout
                expect(assigns(:country)).to eq 'United Kingdom'
            end
        end

        context "if the order has an associated delivery address record" do
            let!(:order) { create(:delivery_address_order, cart_id: cart.id) }

            it "should assign the order's delivery address country attribute value to @country" do
                get :checkout
                expect(assigns(:country)).to eq order.delivery_address.country
            end
        end

        context "if the cart estimate_delivery_id attribute and order delivery address record are both nil" do
            let!(:cart) { create(:cart) }
            let!(:order) { create(:order, cart_id: cart.id) }

            it "should assign nil to @delivery_service_prices" do
                get :checkout
                expect(assigns(:delivery_service_prices)).to eq nil
            end
        end

        context "if the cart estimate_delivery_id attribute or order delivery address record are not nil" do

            it "should assign the available delivery service prices to @delivery_service_prices" do
                get :checkout
                expect(assigns(:delivery_service_prices)).to match_array(DeliveryServicePrice.find_collection([1,2], cart.estimate_country_name))
            end
        end

        context "if the cart has no associated order" do

            it "should assign a new order record to @order" do
                get :checkout
                expect(assigns(:order)).to be_a_new(Order)
            end

            it "should assign the carts estimate_delivery_id attribute value to @delivery_id" do
                get :checkout
                expect(assigns(:delivery_id)).to eq delivery_service_price.id
            end

            it "should assign a new address record to @delivery_address" do
                get :checkout
                expect(assigns(:delivery_address)).to be_a_new(Address)
            end

            it "should assign a new address record to @billing_address" do
                get :checkout
                expect(assigns(:billing_address)).to be_a_new(Address)
            end
        end

        context "if the cart has an associated order" do
            let!(:order) { create(:order, cart_id: cart.id) }

            it "should assign the order delivery_id attribute value to @delivery_id" do
                get :checkout
                expect(assigns(:delivery_id)).to eq order.delivery_id
            end
        end
    end

    describe 'POST #confirm' do
        let!(:cart) { create(:cart) }
        before(:each) do
            stub_current_cart(cart)
        end

        it "should assign the payment_type parameter to the session store" do
            post :confirm, order: attributes_for(:order), payment_type: 'express-checkout'
            expect(session[:payment_type]).to eq 'express-checkout'
        end

        context "with valid attributes" do
            let!(:delivery_service_price) { create(:delivery_service_price) }
            before(:each) do
                Store.PayProvider.any_instance.stub(build: '/')
            end

            it "should not have a nil value for net_amount, tax_amount and gross_amount attributes for the new order" do
                post :confirm, order: attributes_for(:order, delivery_id: delivery_service_price.id), payment_type: 'express-checkout'
                expect(assigns(:order).net_amount).to_not be_nil
                expect(assigns(:order).tax_amount).to_not be_nil
                expect(assigns(:order).gross_amount).to_not be_nil
            end

            it "should set the cart_id attribute for the new order" do
                post :confirm, order: attributes_for(:order, delivery_id: delivery_service_price.id), payment_type: 'express-checkout'
                expect(assigns(:order).cart_id).to eq cart.id
            end

            it "should save a new order to the database" do
                expect{
                    post :confirm, order: attributes_for(:order, delivery_id: delivery_service_price.id), payment_type: 'express-checkout'
                }.to change(Order, :count).by(1)
            end
        end

        context "with invalid attributes" do

            it "should render the checkout template" do
                post :confirm, order: attributes_for(:order, email: nil), payment_type: 'express-checkout'
                expect(response).to render_template :checkout
            end
        end
    end

    describe 'PATCH #estimate' do
        let!(:cart) { create(:cart, estimate_country_name: 'United Kingdom') }
        before(:each) do
            stub_current_cart(cart)
        end

        context "with valid attributes" do

            it "should render the success partial" do
                xhr :patch, :estimate, cart: attributes_for(:cart)
                expect(response).to render_template(partial: "themes/#{Store.settings.theme.name}/carts/delivery_service_prices/estimate/_success")
            end
        end

        context "with invalid attributes" do
            let(:errors) { "{\"estimate_country_name\":[\"can't be blank\"]}" }

            it "should return a JSON object of errors" do
                xhr :patch, :estimate, cart: attributes_for(:cart, estimate_country_name: nil)
                expect(cart.errors.to_json(root: true)).to eq errors
            end

            it "should return a 422 status code" do
                xhr :patch, :estimate, cart: attributes_for(:cart, estimate_country_name: nil)
                expect(response.status).to eq 422
            end
        end
    end

    describe 'DELETE #purge_estimate' do
        let!(:delivery_service_price) { create(:delivery_service_price) }
        let!(:cart) { create(:cart, estimate_country_name: 'China', estimate_delivery_id: delivery_service_price.id) }
        before(:each) do
            stub_current_cart(cart)
        end

        it "should update the cart estimate_delivery_id attribute value to nil" do
            expect{
                xhr :delete, :purge_estimate
            }.to change{
                cart.estimate_delivery_id
            }.from(delivery_service_price.id).to(nil)
        end

        it "should update the cart estimate_country_name attribute value to nil" do
            expect{
                xhr :delete, :purge_estimate
            }.to change{
                cart.estimate_country_name
            }.from('China').to(nil)
        end

        it "should render the success partial" do
            xhr :delete, :purge_estimate
            expect(response).to render_template(partial: "themes/#{Store.settings.theme.name}/carts/delivery_service_prices/estimate/_success")
        end
    end
end