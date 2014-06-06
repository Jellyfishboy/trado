require 'spec_helper'

describe Payatron4000 do

    describe "When sending order information to third party services" do
        let(:sku) { create(:sku, price: BigDecimal.new("12.50"), stock: 20) }

        it "should return a price in a single integer" do
            expect(Payatron4000::singularize_price(sku.price)).to eq 1250
        end
    end

    describe "After creating a transaction record for the associated order" do
        let(:order) { create(:complete_order) }
        

        it "should update the relevant SKU's stock" do
            expect {
                Payatron4000::stock_update(order)
            }.to change {
                order.order_items.first.sku.stock }.by(-5)
        end
    end

    describe "After successfully completing an order" do
        let!(:cart) { create(:cart) }
        let!(:session) { Hash({:cart_id => cart.id}) }
        let(:destroy_cart) { Payatron4000::destroy_cart(session) }

        it "should destroy the originating cart and it's cart items" do
            expect{
                destroy_cart
            }.to change(Cart, :count).by(-1)
        end

        it "should set the session[:cart_id] to nil" do
            expect(session[:cart_id]).to eq cart.id
            destroy_cart
            expect(session[:cart_id]).to eq nil
        end
    end

    describe "When adding or modifying an order's shipping/billing address details" do

        context "if the address already exists" do
            let(:address) { create(:address, first_name: 'Tom', last_name: 'Dallimore', city: 'Bristol') }
            let(:result) { Payatron4000::select_address(nil, address.id) }

            it "should return the address record" do
                expect(result.id).to eq address.id
                expect(result.full_name).to eq 'Tom Dallimore'
                expect(result.city).to eq 'Bristol'
            end
        end

        context "if the address does not exist" do
            let(:order) { create(:order) }
            let(:result) { Payatron4000::select_address(order.id, nil) }

            it "should create a new address record" do
                expect(result.addressable_id).to eq order.id
                expect(result.addressable_type).to eq 'Order'
            end
        end
    end
end