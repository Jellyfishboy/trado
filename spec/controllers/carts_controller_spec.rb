require 'rails_helper'

describe CartsController, broken: true do

    store_setting

    describe 'GET #mycart' do
        let!(:cart) { create(:cart) }
        before(:each) do
            stub_current_cart(cart)
        end

        it "should render the mycart template" do
            get :mycart
            expect(response).to render_template :mycart
        end

        it "should assign the calculated cart values to @cart_totals" do
            get :checkout
            expect(assigns(:cart_totals)).to eq cart.calculate(0.2)
        end
    end

    describe 'GET #checkout' do
        let(:delivery_service) { create(:delivery_service_with_countries) }
        let!(:delivery_service_price) { create(:delivery_service_price, delivery_service: delivery_service) }
        let!(:cart) { create(:cart, delivery_id: delivery_service_price.id, country: 'United Kingdom', delivery_service_ids: DeliveryServicePrice.all.map(&:id)) }
        before(:each) do
            stub_current_cart(cart)
        end

        it "should assign the calculated cart values to @cart_totals" do
            get :checkout
            expect(assigns(:cart_totals)).to eq cart.calculate(0.2)
        end

        context "if the order doesn't have an associated delivery address record" do

            it "should assign the cart country attribute value to @cart_session[:country]" do
                get :checkout
                expect(assigns(:cart_session)[:country]).to eq 'United Kingdom'
            end
        end

        context "if the order has an associated delivery address record" do
            let!(:order) { create(:delivery_address_order, cart_id: cart.id) }

            it "should assign the order's delivery address country attribute value to @cart_session[:country]" do
                get :checkout
                expect(assigns(:cart_session)[:country]).to eq order.delivery_address.country
            end
        end

        context "if the cart delivery_id attribute and order delivery address record are both nil" do
            let!(:cart) { create(:cart) }
            let!(:order) { create(:order, cart_id: cart.id) }

            it "should assign nil to @delivery_services" do
                get :checkout
                expect(assigns(:delivery_services)).to eq []
            end
        end

        context "if the cart delivery_id attribute or order delivery address record are not nil" do

            it "should assign the available delivery service prices to @delivery_services" do
                get :checkout
                expect(assigns(:delivery_services)).to match_array(DeliveryServicePrice.find_collection(cart.delivery_service_ids, cart.country))
            end
        end

        context "if the cart has no associated order" do

            it "should assign a new order record to @order" do
                get :checkout
                expect(assigns(:order)).to be_a_new(Order)
            end

            it "should assign the carts delivery_id attribute value to @cart_session[:delivery_id]" do
                get :checkout
                expect(assigns(:cart_session)[:delivery_id]).to eq delivery_service_price.id
            end
        end

        context "if the cart has an associated order" do
            let!(:order) { create(:order, cart_id: cart.id) }

            it "should assign the order delivery_id attribute value to @cart_session[:delivery_id]" do
                get :checkout
                expect(assigns(:cart_session)[:delivery_id]).to eq order.delivery_id
            end
        end
    end

    # describe 'POST #confirm' do
    #     let!(:cart) { create(:cart) }
    #     before(:each) do
    #         stub_current_cart(cart)
    #     end

    #     it "should assign the payment_type parameter to the session store" do
    #         post :confirm, order: attributes_for(:order), payment_type: 'paypal'
    #         expect(session[:payment_type]).to eq 'paypal'
    #     end

    #     context "with valid attributes" do
    #         let!(:delivery_service_price) { create(:delivery_service_price) }
    #         before(:each) do
    #             Store::PayProvider.any_instance.stub(build: '/')
    #         end

    #         it "should not have a nil value for net_amount, tax_amount and gross_amount attributes for the new order" do
    #             post :confirm, order: attributes_for(:order, delivery_id: delivery_service_price.id), payment_type: 'paypal'
    #             expect(assigns(:order).net_amount).to_not be_nil
    #             expect(assigns(:order).tax_amount).to_not be_nil
    #             expect(assigns(:order).gross_amount).to_not be_nil
    #         end

    #         it "should set the cart_id attribute for the new order" do
    #             post :confirm, order: attributes_for(:order, delivery_id: delivery_service_price.id), payment_type: 'paypal'
    #             expect(assigns(:order).cart_id).to eq cart.id
    #         end

    #         it "should save a new order to the database" do
    #             expect{
    #                 post :confirm, order: attributes_for(:order, delivery_id: delivery_service_price.id), payment_type: 'paypal'
    #             }.to change(Order, :count).by(1)
    #         end
    #     end

    #     context "with invalid attributes" do

    #         it "should render the checkout template" do
    #             post :confirm, order: attributes_for(:order, email: nil), payment_type: 'paypal'
    #             expect(response).to render_template :checkout
    #         end
    #     end
    # end

    # describe 'PATCH #estimate' do
    #     let!(:cart) { create(:cart, country: 'United Kingdom') }
    #     before(:each) do
    #         stub_current_cart(cart)
    #     end

    #     context "with valid attributes" do

    #         it "should render the success partial" do
    #             xhr :patch, :estimate, cart: attributes_for(:cart)
    #             expect(response).to render_template(partial: "themes/#{Store.settings.theme.name}/carts/delivery_service_prices/estimate/_success")
    #         end
    #     end

    #     context "with invalid attributes" do
    #         let(:errors) { "{\"country\":[\"can't be blank\"]}" }

    #         it "should return a JSON object of errors" do
    #             xhr :patch, :estimate, cart: attributes_for(:cart, country: nil)
    #             expect(cart.errors.to_json(root: true)).to eq errors
    #         end

    #         it "should return a 422 status code" do
    #             xhr :patch, :estimate, cart: attributes_for(:cart, country: nil)
    #             expect(response.status).to eq 422
    #         end
    #     end
    # end

    # describe 'DELETE #purge_estimate' do
    #     let!(:delivery_service_price) { create(:delivery_service_price) }
    #     let!(:cart) { create(:cart, country: 'China', delivery_id: delivery_service_price.id) }
    #     before(:each) do
    #         stub_current_cart(cart)
    #     end

    #     it "should update the cart delivery_id attribute value to nil" do
    #         expect{
    #             xhr :delete, :purge_estimate
    #         }.to change{
    #             cart.delivery_id
    #         }.from(delivery_service_price.id).to(nil)
    #     end

    #     it "should update the cart country attribute value to nil" do
    #         expect{
    #             xhr :delete, :purge_estimate
    #         }.to change{
    #             cart.country
    #         }.from('China').to(nil)
    #     end

    #     it "should render the success partial" do
    #         xhr :delete, :purge_estimate
    #         expect(response).to render_template(partial: "themes/#{Store.settings.theme.name}/carts/delivery_service_prices/estimate/_success")
    #     end
    # end
end