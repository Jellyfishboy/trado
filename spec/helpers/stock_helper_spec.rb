require 'rails_helper'

describe StockHelper do

    describe '#latest_stock_adjustment' do
        let!(:sku) { create(:sku, active: true) }
        let!(:stock_adjustment) { create(:stock_adjustment, sku_id: sku.id, created_at: Date.yesterday) }
        
        context "if the stock adjustment is equal to the latest SKU stock adjustment record" do

            it "should return a string" do
                expect(latest_stock_adjustment(stock_adjustment, sku)).to eq 'td-green'
            end
        end
        context "if the stock adjustment is not equal to the latest SKU stock adjustment record" do
            before(:each) do
                create(:stock_adjustment, sku_id: sku.id)
            end

            it "should return nil" do
                expect(latest_stock_adjustment(stock_adjustment, sku)).to eq nil
            end
        end
    end
end