require 'rails_helper'

describe Store::Price do

    store_setting

    describe "When converting a price for third party services" do

        context "if the tax breakdown Store setting is true" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: true)
                Store::settings
            end

            context "if the args array has a 'gross' string value" do
                let(:sku) { create(:sku, price: '11.50') }
                
                it "should return a decimal price with tax" do
                    expect(Store::Price.new(sku.price, 'gross').singularize).to eq 1380
                end
            end

            context "if the args array does not have a 'gross' string value" do
                let(:sku) { create(:sku, price: '22.67') }
                
                it "should return a decimal price without tax" do
                    expect(Store::Price.new(sku.price).singularize).to eq 2267
                end
            end
        end

        context "if the tax breakdown Store setting is false" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: false)
                Store::settings
            end

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

        context "if the tax breakdown Store setting is true" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: true)
                Store::settings
            end

            context "if the args array has a 'gross' string value" do
                let(:sku) { create(:sku, price: '11.50') }
                
                it "should return a formatted decimal price with tax" do
                    expect(Store::Price.new(sku.price, 'gross').format).to eq '£13.80'
                end
            end

            context "if the args array does not have a 'gross' string value" do
                let(:sku) { create(:sku, price: '22.67') }
                
                it "should return a formatted decimal price without tax" do
                    expect(Store::Price.new(sku.price).format).to eq '£22.67'
                end
            end
        end

        context "if the tax breakdown Store setting is false" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: false)
                Store::settings
            end

            context "if the args array has a 'net' string value" do
                let(:sku) { create(:sku, price: '22.67') }

                it "should return a formatted decimal price without tax" do
                    expect(Store::Price.new(sku.price, 'net').format).to eq '£22.67'
                end
            end

            context "if the args array does not have a 'net' string value" do
                let(:sku) { create(:sku, price: '283.67') }

                it "should return a formatted decimal price with tax" do
                    expect(Store::Price.new(sku.price).format).to eq '£340.40'
                end
            end
        end
    end

    describe "When rendering price markup for a view" do

        context "if the tax breakdown Store setting is true" do
            let!(:sku) { create(:sku, price: '48.93') }
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: true, tax_name: 'VAT')
                Store::settings
            end

            it "should have the correct elements" do
                expect(Store::Price.new(sku.price).markup).to include("<span class='tax-suffix'>#{Store::Price.new(sku.price, 'gross').format} Inc VAT</span>")
            end
        end

        context "if the tax breakdown Store setting is false" do
            let!(:sku) { create(:sku, price: '48.93') }

            it "should have the correct elements" do
                expect(Store::Price.new(sku.price).markup).to_not include("<span>#{Store::Price.new(sku.price).format}</span>")
            end
        end
    end
end