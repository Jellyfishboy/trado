require 'spec_helper'

describe Store do

    before(:each) { Store.class_variable_set :@@store_settings, nil }

    describe "When utilising store wide settings" do
        let!(:settings) { create(:store_setting) }

        it "should assign a store_settings object to a class variable and return" do
            expect(Store::settings).to eq settings
        end
    end

    describe "After modifying store wide settings" do
        let!(:settings) { create(:store_setting) }
        it "should set the store_settings class variable to nil" do
            expect(Store::settings).to eq settings
            Store::reset_settings
            expect(Store.class_variable_get(:@@store_settings)).to eq nil
        end
    end

    describe "When using the store tax_rate in calculations" do
        let!(:settings) { create(:store_setting, tax_rate: "15.4") }

        it "should divide the tax_rate value by 100" do
            expect(Store::tax_rate).to eq BigDecimal.new("0.154")
        end
    end

    describe "When calculating positive and negative numbers" do

        context "if its a positive value" do

            it "should return true" do
                expect(Store::positive?(5)).to be_true
            end
        end

        context "if its a negative value" do

            it "should return false" do
                expect(Store::positive?(-50)).to be_false
            end
        end
    end

    describe "When a redundant record is updated or deleted" do
        let(:product) { create(:product, active: true) }

        it "should set the record as inactive" do
            Store::inactivate!(product)
            expect(product.active).to be_false
        end
    end

    describe "When the record fails to update" do
        let(:product) { create(:product) }

        it "should set the record as active" do
            Store::activate!(product)
            expect(product.active).to be_true
        end
    end
end