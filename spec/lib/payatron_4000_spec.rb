require 'spec_helper'

describe Payatron4000 do

    describe "After creating a transaction record for the associated order" do
        let(:order) { create(:complete_order) }
        let(:update) { Payatron4000::stock_update(order) }

        it "should update the relevant SKU's stock" do
            expect {
                update
            }.to change {
                order.order_items.first.sku.stock }.by(-5)
        end

        it "should create a new StockLevel record" do
            expect{
                update
            }.to change(StockLevel, :count).by(1)
        end

        it "should have the correct adjustment in the StockLevel record" do
            update
            expect(order.order_items.first.sku.stock_levels.first.adjustment).to eq -5
        end

        context "if the order item has no accessory" do
            let(:order) { create(:complete_order) }

            it "should have only the order id in the description" do
                Payatron4000::stock_update(order)
                expect(order.order_items.first.sku.stock_levels.first.description).to eq "Order ##{order.id}"
            end
        end

        context "if the order item has an accessory" do
            let(:order) { create(:complete_accessory_order) }

            it "should have the order id and accessory name in the description" do
                Payatron4000::stock_update(order)
                expect(order.order_items.first.sku.stock_levels.first.description).to eq "Order ##{order.id} (+ #{order.order_items.first.order_item_accessory.accessory.name})"
            end
        end
    end

    describe "After successfully completing an order" do
        let!(:cart) { create(:cart) }
        let(:session) { Hash({:cart_id => cart.id}) }
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