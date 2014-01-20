require 'spec_helper'

describe CartItem do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }
    it { expect(subject).to belong_to(:cart) }

    it "should return the sum of price multiplied by quantity" do
        cart_item = build(:cart_item, price: 12, quantity: 7)
        expect(cart_item.total_price).to eq 84
    end

end