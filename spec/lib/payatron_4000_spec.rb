require 'rails_helper'

describe Payatron4000 do

    describe "After creating a transaction record for the associated order" do
        let(:order) { create(:complete_order) }
        let(:update) { Payatron4000::update_stock(order) }

        it "should set the correct stock_total for the new stock_adjustment record" do
            original_stock = order.order_items.first.sku.stock_adjustments.first.stock_total
            update
            expect(order.order_items.first.sku.stock_total).to eq original_stock - 5
        end

        it "should update the relevant SKU's stock" do
            expect {
                update
            }.to change {
                order.order_items.first.sku.stock }.by(-5)
        end

        it "should create a new StockAdjustment record" do
            expect{
                update
            }.to change(StockAdjustment, :count).by(3)
        end

        it "should have the correct adjustment in the StockAdjustment record" do
            update
            expect(order.order_items.first.sku.stock_adjustments.first.adjustment).to eq -5
        end

        context "if the order item has no accessory" do
            let(:order) { create(:complete_order) }

            it "should have only the order id in the description" do
                Payatron4000::update_stock(order)
                expect(order.order_items.first.sku.stock_adjustments.first.description).to eq "Order ##{order.id}"
            end
        end

        context "if the order item has an accessory" do
            let(:order) { create(:complete_accessory_order) }

            it "should have the order id and accessory name in the description" do
                Payatron4000::update_stock(order)
                expect(order.order_items.first.sku.stock_adjustments.first.description).to eq "Order ##{order.id} (+ #{order.order_items.first.order_item_accessory.accessory.name})"
            end
        end
    end

    describe "After successfully completing an order" do
        let!(:cart) { create(:cart) }
        let!(:complete_order) { create(:pending_order, cart_id: cart.id) }
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

        it "should update all the associated products order count attribute value" do
            expect{
                Payatron4000::increment_product_order_count(cart.order.products)
            }.to change{
                cart.order.products.first.order_count
            }.from(0).to(1)
        end

        it "should decommission an order by setting the cart_id attribute to nil" do
            expect(complete_order.cart_id).to_not eq nil
            Payatron4000::decommission_order(complete_order)
            expect(complete_order.cart_id).to eq nil
        end
    end

    describe "When checking if a transaction has a fatal error code" do

        it "should return true if the error code is listed as fatal" do
            expect(Payatron4000::fatal_error_code?(10415)).to eq true
        end

        it "should return false if the error code is not listed as fatal" do
            expect(Payatron4000::fatal_error_code?(10413)).to eq false
        end
    end
end