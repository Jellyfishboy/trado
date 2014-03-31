require 'spec_helper'
require 'bigdecimal'

describe CartItem do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }
    it { expect(subject).to belong_to(:cart) }
    it { expect(subject).to have_one(:cart_item_accessory).dependent(:delete) }

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:cart_item_accessory) }

    describe "When calculating a cart item total" do
        let!(:cart_item) { build(:cart_item, price: 12, quantity: 7) }
        it "should return the sum of price multiplied by quantity" do
            expect(cart_item.total_price).to eq 84
        end
    end

    describe  "Updating quantity" do
        let!(:cart_item) { create(:update_cart_item_quantity) }

        before(:each) do
            cart_item.update_quantity(10, cart_item.cart_item_accessory)
        end
        it "should update the cart_item quantity" do
            expect(cart_item.quantity).to eq 10
        end
        context "if there is a cart_item_accessory" do
            it "should update the cart_item_accessory quantity" do
                expect(cart_item.cart_item_accessory.quantity).to eq 10
            end
        end
    end

    describe "Update weight" do

        let!(:cart_item) { create(:cart_item, weight: BigDecimal.new("20.1"))}
        let!(:cart_accessory) { create(:update_cart_item_weight) }

        before(:each) do
            cart_item.update_weight(12, cart_item.weight, nil)
            cart_accessory.update_weight(12, cart_accessory.weight, cart_accessory.cart_item_accessory.accessory)
        end

        context "without a cart_item_accessory" do

            it "should calculate the weight of the cart_item" do
                expect(cart_item.weight).to eq BigDecimal.new("241.2") 
            end
        end

        context "with a cart_item_accessory" do
            
            it "should calculate the weight of the cart_item, including the cart_item_accessory weight" do
                expect(cart_accessory.weight).to eq BigDecimal.new("192")
            end
        end
    end
end