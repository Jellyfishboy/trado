require 'spec_helper'

describe StockLevel do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }

    # Validation
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:adjustment) }

    describe "Default scope" do
        let!(:stock_level_1) { create(:stock_level, created_at: 1.hour.ago) }
        let!(:stock_level_2) { create(:stock_level, created_at: 6.hours.ago) }
        let!(:stock_level_3) { create(:stock_level, created_at: Time.now) }

        it "should return an array of stock_levels ordered by descending created_at" do
            expect(StockLevel.last(3)).to match_array([stock_level_3, stock_level_1, stock_level_2])
        end
    end

    describe "Validating the stock value before an adjustment value is applied" do

        it "should call stock_level_adjustment method before a save" do
            StockLevel._save_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:stock_level_adjustment).should == true
        end

        context "if the adjustment value results in a negative stock value" do
             let!(:sku) { create(:negative_stock_level_sku, stock: 8) }

            it "should update the SKU stock value with the associated stock level adjustment value" do
                expect(sku.stock).to eq 5
            end
        end

        context "if the adjustment value results in a positive stock value" do
            let(:sku) { create(:positive_stock_level_sku, stock: 10) }

            it "should update the SKU stock value with the associated stock level adjustment value" do
                expect(sku.stock).to eq 13
            end
        end
    end

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

end
