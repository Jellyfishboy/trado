require 'rails_helper'

describe CartItemsController do

    store_setting

    describe 'POST #create' do
        let!(:sku) { create(:sku) }
        let!(:cart) { create(:cart) }
        before(:each) do
            session[:payment_type] = 'express-checkout'
            session[:delivery_service_prices] = [1,2,5]
        end

        it "should assign the related SKU to @sku" do
            xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, sku_id: sku.id)
            expect(assigns(:sku)).to eq sku
        end

        it "should assign the updated cart item to @cart_item" do 
            xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, quantity: 4, sku_id: sku.id)
            expect(assigns(:cart_item).sku).to eq sku
            expect(assigns(:cart_item).quantity).to eq 4
        end

        it "should save a new cart item to the database" do
            expect{
                xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, sku_id: sku.id)
            }.to change(CartItem, :count).by(1)
        end

        context "with valid attributes" do

            it "should render the update partial" do
                xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, quantity: 3, sku_id: sku.id)
                expect(response).to render_template(partial: "themes/#{Store::settings.theme.name}/carts/_update")
            end
        end

        context "if the product has an accessory" do
            let!(:accessory) { create(:accessory) }

            it "should save a new cart item accessory to the database" do
                expect{
                    xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, sku_id: sku.id, quantity: 2,cart_item_accessory: attributes_for(:cart_item_accessory, accessory_id: accessory.id))
                }.to change(CartItemAccessory, :count).by(1)
            end
        end

        context "if the cart item quantity is less than the SKU stock count" do
            let!(:sku) { create(:sku, stock: 15) }

            it "should render the update partial" do
                xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, quantity: 3, sku_id: sku.id)
                expect(response).to render_template(partial: "themes/#{Store::settings.theme.name}/carts/_update")
            end
        end

        context "if the cart item quantity is more than the SKU stock count" do
            let!(:sku) { create(:sku, stock: 15) }

            it "should render the cart items validate failed partial" do
                xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, quantity: 17, sku_id: sku.id)
                expect(response).to render_template(partial: "themes/#{Store::settings.theme.name}/carts/cart_items/validate/_failed")
            end
        end 

        context "if the current cart has an estimate_delivery_id" do
            let!(:cart) { create(:cart, estimate_delivery_id: 1, estimate_country_name: 'China') }
            before(:each) do
                stub_current_cart(cart)
            end

            it "should set estimate_delivery_id attribute to nil value" do
                expect{
                    xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, sku_id: sku.id)
                }.to change{
                    cart.estimate_delivery_id
                }.from(1).to(nil)
            end

            it "should set estimate_country_name attribute to nil value" do
                expect{
                    xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, sku_id: sku.id)
                }.to change{
                    cart.estimate_country_name
                }.from('China').to(nil)
            end
        end

        it "should set the payment_type session store value to nil" do
            xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, sku_id: sku.id)
            expect(session[:payment_type]).to eq nil
        end

        it "should set the delivery_service_prices session store value to be an empty array" do
            xhr :post, :create, cart_id: cart.id, cart_item: attributes_for(:cart_item, sku_id: sku.id)
            expect(session[:delivery_service_prices]).to eq []
        end
    end

    describe 'PATCH #update' do
        let!(:cart) { create(:cart) }
        let!(:cart_item) { create(:cart_item, cart: cart) }

        context "if the cart item has an associated cart item accessory" do
            let!(:cart_item) { create(:accessory_cart_item, cart: cart) }

            it "should assign it's accessory to @accessory" do
                xhr :patch, :update, cart_id: cart.id, id: cart_item.id, cart_item: attributes_for(:cart_item, quantity: 3)
                expect(assigns(:accessory)).to eq cart_item.cart_item_accessory.accessory
            end
        end

        context "if the cart item has no associated cart item accessory" do

            it "should assign @accessory to be nil" do
                xhr :patch, :update, cart_id: cart.id, id: cart_item.id, cart_item: attributes_for(:cart_item, quantity: 3)
                expect(assigns(:accessory)).to eq nil     
            end
        end

        it "should update the weight of the cart item" do
            xhr :patch, :update, cart_id: cart.id, id: cart_item.id, cart_item: attributes_for(:cart_item, quantity: 8)
            expect(assigns(:cart_item).weight).to eq (cart_item.sku.weight*8)
        end

        it "should update the quantity of the cart item" do
            xhr :patch, :update, cart_id: cart.id, id: cart_item.id, cart_item: attributes_for(:cart_item, quantity: 5)
            expect(assigns(:cart_item).quantity).to eq 5
        end

        context "if the cart item quantity is zero" do
            let!(:cart_item) { create(:cart_item, quantity: 4, cart: cart) }

            it "should destroy the cart item" do
                expect{
                    xhr :patch, :update, cart_id: cart.id, id: cart_item.id, cart_item: attributes_for(:cart_item, quantity: 0)
                }.to change(CartItem, :count).by(-1)
            end
        end

        context "if the cart item quantity is more than zero and the cart item updates successfully" do
            let!(:cart_item) { create(:cart_item, quantity: 8, cart: cart) }

            it "should render the update partial" do
                xhr :patch, :update, cart_id: cart.id, id: cart_item.id, cart_item: attributes_for(:cart_item, quantity: 6)
                expect(response).to render_template(partial: "themes/#{Store::settings.theme.name}/carts/_update")
            end
        end

        context "if the cart item quantity is less than the SKU stock count" do
            let!(:sku) { create(:sku, stock: 15) }
            let!(:cart_item) { create(:cart_item, sku_id: sku.id, quantity: 14, cart: cart) }

            it "should render the update partial" do
                xhr :patch, :update, cart_id: cart.id, id: cart_item.id, cart_item: attributes_for(:cart_item, quantity: 3, sku_id: sku.id)
                expect(response).to render_template(partial: "themes/#{Store::settings.theme.name}/carts/_update")
            end
        end

        context "if the cart item quantity is more than the SKU stock count" do
            let!(:sku) { create(:sku, stock: 15) }
            let!(:cart_item) { create(:cart_item, sku_id: sku.id, quantity: 14, cart: cart) }

            it "should render the cart items validate failed partial" do
                xhr :patch, :update, cart_id: cart.id, id: cart_item.id, cart_item: attributes_for(:cart_item, quantity: 17, sku_id: sku.id)
                expect(response).to render_template(partial: "themes/#{Store::settings.theme.name}/carts/cart_items/validate/_failed")
            end
        end 
    end

    describe 'DELETE #destroy' do
        let!(:cart) { create(:cart) }
        let!(:cart_item) { create(:cart_item, cart: cart) }

        it "should delete the cart item" do            
            expect{
                xhr :delete, :destroy, cart_id: cart.id, id: cart_item.id
            }.to change(CartItem, :count).by(-1)
        end

        it "should render the update partial" do
            xhr :delete, :destroy, cart_id: cart.id, id: cart_item.id
            expect(response).to render_template(partial: "themes/#{Store::settings.theme.name}/carts/_update")
        end
    end
end