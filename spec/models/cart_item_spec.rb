require 'spec_helper'

describe CartItem do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }
    it { expect(subject).to belong_to(:cart) }
    it { expect(subject).to have_one(:cart_item_accessory).dependent(:delete) }

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:cart_item_accessory) }

    it "should return the sum of price multiplied by quantity" do
        cart_item = build(:cart_item, price: 12, quantity: 7)
        expect(cart_item.total_price).to eq 84
    end

    it "should update the quantity of the cart item, and it's associated accessory if necessary"
    it "should update the weight of the cart item, including accessory weight if necessary"

end