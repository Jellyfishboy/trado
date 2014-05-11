require 'spec_helper'
require 'bigdecimal'

describe Payatron4000 do
    
    let(:sku) { create(:sku, price: BigDecimal.new("12.50"), stock: 20) }
    let(:order) { create(:complete_order) }

    it "should calculate a price in pennies" do
        expect(Payatron4000::singularize_price(sku.price)).to eq 1250
    end

    it "should update the SKU's stock" do
        expect {
            Payatron4000::stock_update(order)
        }.to change {
            order.order_items.first.sku.stock }.by(-5)
    end
end