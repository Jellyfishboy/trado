require 'spec_helper'

describe OrderItem do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }
    it { expect(subject).to belong_to(:order) }
    it { expect(subject).to have_one(:order_item_accessory).dependent(:delete) }

    it "should return the sum of price multiplied by quantity" do
        order_item = build(:order_item, price: 12, quantity: 7)
        expect(order_item.total_price).to eq 84
    end

end