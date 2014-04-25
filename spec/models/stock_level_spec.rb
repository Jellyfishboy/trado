require 'spec_helper'

describe StockLevel do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }

    # Validation
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:adjustment) }

    describe "Validating the adjustment value is greater than or less than zero" do

        context "if the adjustment value is zero" do
            let(:stock_level) { build(:stock_level, adjustment: 0) }

            it "should return an error" do
                expect(stock_level).to have(1).errors_on(:adjustment)
            end
        end

        context "if the adjustment value is a above zero" do
            let(:stock_level) { create(:stock_level, adjustment: 3) }

            it "should set the correct adjustment value" do
                expect(stock_level.adjustment).to eq 3
            end
        end

    end

    describe "Validatiing the stock value before an adjustment value is applied" do

        context "if the adjustment value results in a negative stock value" do

            it "should produce an error"

        end

        context "if the adjustment value results in a positive stock value" do
            let(:sku) { create(:sku_stock_level, stock: 10) }

            it "should update the SKU stock value with the associated stock level adjustment value" do
                expect(sku.stock).to eq 13
            end
        end
    end

end
