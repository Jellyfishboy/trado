require 'rails_helper'

describe StockAdjustment do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }

    # Validation
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:adjustment) }

    describe "Validating the stock value before an adjustment value is applied" do
        let!(:sku) { create(:sku, stock: 10) }

        it "should call stock_adjustment_adjustment method before a save" do
            StockAdjustment._save_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:stock_adjustment).should == true
        end

        context "if the adjustment value results in a negative stock value" do
            let!(:stock_adjustment) { create(:stock_adjustment, adjustment: -5, description: 'Order #1', sku_id: sku.id)}

            it "should set the correct stock_total value for the new stock adjustment record" do
                sku.reload
                expect(sku.stock_total).to eq 5
            end

            it "should set the correct stock_total value for the new stock adjustment record" do
                sku.reload
                expect(sku.stock).to eq 5
            end
        end

        context "if the adjustment value results in a positive stock value" do
            let!(:stock_adjustment) { create(:stock_adjustment, adjustment: 3, description: 'New stock', sku_id: sku.id) }

            it "should set the correct stock_total value for the new stock adjustment record" do
                sku.reload
                expect(sku.stock_total).to eq 13
            end

            it "should set the correct stock_total value for the new stock adjustment record" do
                sku.reload
                expect(sku.stock).to eq 13
            end
        end
    end

    describe "Determining if this is the first stock adjustment record for a SKU" do

        context "if the SKU has prior stock adjustment records" do
            let!(:sku) { create(:sku, active: true) }
            let(:stock_adjustment) { build(:stock_adjustment, sku_id: sku.id) }

            it "should return true" do
                expect(stock_adjustment.not_initial_stock_adjustment?).to eq true
            end
        end

        context "if the SKU has no prior stock adjustment records" do
            let!(:sku) { create(:skip_after_stock_adjustment_sku, active: true) }
            let(:stock_adjustment) { build(:stock_adjustment, sku_id: sku.id) }

            it "should return false" do
                expect(stock_adjustment.not_initial_stock_adjustment?).to eq false
            end
        end
    end

    describe "Validating the adjustment value is greater than or less than zero" do

        context "if the adjustment value is zero" do
            let(:stock_adjustment) { build(:stock_adjustment, adjustment: 0) }

            it "should return an error" do
                expect(stock_adjustment).to have(1).errors_on(:adjustment)
            end
        end

        context "if the adjustment value is a above zero" do
            let(:sku) { create(:skip_after_stock_adjustment_sku, active: true)}
            let(:stock_adjustment) { create(:stock_adjustment, adjustment: 3, sku_id: sku.id) }

            it "should set the correct adjustment value" do
                expect(stock_adjustment.adjustment).to eq 3
            end
        end

    end

end
