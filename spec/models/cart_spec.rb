require 'spec_helper'

describe Cart do

    # ActiveRecord relations
    it { expect(subject).to have_many(:cart_items).dependent(:delete_all) }
    it { expect(subject).to have_many(:skus).through(:cart_items) }

    context "When retrieving the cart total value" do

        it "should iterate through all cart items and calculate the sum" do
            cart = create(:cart)
            cart_item_1 = create(:cart_item, price: 12, quantity: 1, cart: cart)
            cart_item_2 = create(:cart_item, price: 6.50, quantity: 4, cart: cart)
            cart_item_3 = create(:cart_item, price: 3.20, quantity: 2, cart: cart)
            expect(cart.cart_items.count).to eq 3
            expect(cart.cart_items.sum('quantity')).to eq 7
            expect(cart.total_price).to eq BigDecimal.new("44.40")
        end
    end

    context "During a daily scheduled task" do

        it "should remove any carts which are more than 12 hours old" do
            cart_1 = create(:cart, updated_at: 11.hours.ago)
            cart_2 = create(:cart, updated_at: 13.hours.ago)
            cart_3 = create(:cart, updated_at: 28.hours.ago)
            expect(Cart.clear_carts).to match_array([cart_2, cart_3])
        end
    end

end