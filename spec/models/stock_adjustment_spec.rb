# == Schema Information
#
# Table name: stock_adjustments
#
#  id          :integer          not null, primary key
#  description :string
#  adjustment  :integer          default(1)
#  sku_id      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  stock_total :integer
#

require 'rails_helper'

describe StockAdjustment do

    # # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }

    # # Validation
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:adjustment) }

    describe "Validating the stock value before an adjustment value is applied" do
        let!(:sku) { create(:sku, stock: 10) }

        it "should call adjust_sku_stock method before a save" do
            StockAdjustment._save_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:adjust_sku_stock).should == true
        end

        context "if the adjustment value results in a negative stock value" do
            let!(:stock_adjustment) { create(:stock_adjustment, adjustment: -5, description: 'Order #1', sku_id: sku.id)}


            it "should set the correct value for the sku stock attribute" do
                sku.reload
                expect(sku.stock).to eq 5
            end
        end

        context "if the adjustment value results in a positive stock value" do
            let!(:stock_adjustment) { create(:stock_adjustment, adjustment: 3, description: 'New stock', sku_id: sku.id) }

            it "should set the correct value for the sku stock attribute" do
                sku.reload
                expect(sku.stock).to eq 13
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
            let(:sku) { create(:sku, active: true)}
            let(:stock_adjustment) { create(:stock_adjustment, adjustment: 3, sku_id: sku.id) }

            it "should set the correct adjustment value" do
                expect(stock_adjustment.adjustment).to eq 3
            end
        end
    end

    describe 'When setting the adjusted_at datetime value' do

        context "if the record is not a duplicate" do
            let(:sku) { create(:sku, active: true) }
            let(:stock_adjustment) { build(:stock_adjustment, sku: sku) }

            it "should not set the adjusted_at attribute to current time" do
                Timecop.freeze(Time.current) do
                    expect{
                        stock_adjustment.save
                    }.to change{
                        stock_adjustment.adjusted_at
                    }.from(nil).to(Time.current)
                end
            end
        end

        context "if the record is a duplicate" do
            let(:sku) { create(:sku, active: true) }
            let(:stock_adjustment) { build(:stock_adjustment, sku: sku, duplicate: true, adjusted_at: 1.day.ago) }

            it "should not change the adjusted_at attribute" do
                expect{
                    stock_adjustment.save
                }.to_not change{
                    stock_adjustment.adjusted_at
                }
            end
        end
    end

    describe "Validating collection of StockAdjustment records" do

        context "if the collection has an invalid record" do
            let(:collection) { attributes_for_list(:stock_adjustment, 3, adjustment: nil) }            

            it "should return false" do
                expect(StockAdjustment.valid_collection?(collection)).to eq false
            end
        end

        context "if the collection has all valid records" do
            let(:collection) { attributes_for_list(:stock_adjustment, 5) }            

            it "should return true" do
                expect(StockAdjustment.valid_collection?(collection)).to eq true
            end
        end
    end
end
