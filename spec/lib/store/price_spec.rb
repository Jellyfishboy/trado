require 'spec_helper'

describe Store::Price do

    store_setting

    describe "When converting a price for third party services" do

        context "if the tax breakdown Store setting is true" do

            context "if the args array has a 'gross' string value" do
                let(:sku) { create(:sku, price: '11.50') }

                it "should return a decimal price with tax" do
                    Store::reset_settings
                    StoreSetting.destroy_all
                    create(:store_setting, tax_breakdown: true)
                    Store::settings
                    expect(Store::Price.new(sku.price, 'gross').singularize).to eq 1380
                end
            end

            context "if the args array does not have a 'gross' string value" do
                let(:sku) { create(:sku, price: '22.67') }
                
                it "should return a decimal price without tax" do
                    Store::reset_settings
                    StoreSetting.destroy_all
                    create(:store_setting, tax_breakdown: true)
                    Store::settings
                    expect(Store::Price.new(sku.price).singularize).to eq 2267
                end
            end
        end

        context "if the tax breakdown Store setting is false" do

            context "if the args array has a 'net' string value" do
                let(:sku) { create(:sku, price: '22.67') }

                it "should return a decimal price without tax" do
                    expect(Store::Price.new(sku.price, 'net').singularize).to eq 2267
                end
            end

            context "if the args array does not have a 'net' string value" do
                let(:sku) { create(:sku, price: '283.67') }

                it "should return a decimal price with tax" do
                    expect(Store::Price.new(sku.price).singularize).to eq 34040
                end
            end
        end
    end

    describe "When formatting a price ready for a view" do
        let(:sku) { create(:sku, price: '48.93') }

        it "should return a string without tax" do
            expect(Store::Price.new(sku.price, 'net').format).to eq '£48.93'
        end

        it "should return a string with tax" do
            expect(Store::Price.new(sku.price).format).to eq '£58.72'
        end
    end

    describe "When rendering price markup for a view" do

        context "if the tax breakdown Store setting is true" do
            let(:sku) { create(:sku, price: '48.93') }

            it "should have the correct elements" do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: true)
                Store::settings
                expect(Store::Price.new(sku.price).markup).to include("<span>#{Store::Price.new(sku.price, 'gross').format}</span>")
            end
        end

        context "if the tax breakdown Store setting is false" do
            let(:sku) { create(:sku, price: '48.93') }

            it "should have the correct elements" do
                expect(Store::Price.new(sku.price).markup).to_not include("<span>#{Store::Price.new(sku.price).format}</span>")
            end
        end
    end

end