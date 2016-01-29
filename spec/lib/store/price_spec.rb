require 'rails_helper'

describe Store::Price do

    store_setting

    describe "When converting a price for third party services" do

        context "if the tax breakdown Store setting is true" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: true)
                Store.settings
            end

            context "if the args array has a 'gross' string value" do
                let(:sku) { create(:sku, price: '11.50') }
                
                it "should return a decimal price with tax" do
                    expect(Store::Price.new(price: sku.price, tax_type: 'gross').singularize).to eq 1380
                end
            end

            context "if the args array does not have a 'gross' string value" do
                let(:sku) { create(:sku, price: '22.67') }
                
                it "should return a decimal price without tax" do
                    expect(Store::Price.new(price: sku.price).singularize).to eq 2267
                end
            end
        end

        context "if the tax breakdown Store setting is false" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: false)
                Store.settings
            end

            context "if the args array has a 'net' string value" do
                let(:sku) { create(:sku, price: '22.67') }

                it "should return a decimal price without tax" do
                    expect(Store::Price.new(price: sku.price, tax_type: 'net').singularize).to eq 2267
                end
            end

            context "if the args array does not have a 'net' string value" do
                let(:sku) { create(:sku, price: '283.67') }

                it "should return a decimal price with tax" do
                    expect(Store::Price.new(price: sku.price).singularize).to eq 34040
                end
            end
        end
    end

    describe "When rendering a single price for a view" do

        context "if the tax breakdown Store setting is true" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: true)
                Store.settings
            end

            context "if the args array has a 'gross' string value" do
                let(:sku) { create(:sku, price: '11.50') }
                
                it "should return a formatted decimal price with tax" do
                    expect(Store::Price.new(price: sku.price, tax_type: 'gross').single).to eq '£13.80'
                end
            end

            context "if the args array does not have a 'gross' string value" do
                let(:sku) { create(:sku, price: '22.67') }
                
                it "should return a formatted decimal price without tax" do
                    expect(Store::Price.new(price: sku.price).single).to eq '£22.67'
                end
            end
        end

        context "if the tax breakdown Store setting is false" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: false)
                Store.settings
            end

            context "if the args array has a 'net' string value" do
                let(:sku) { create(:sku, price: '22.67') }

                it "should return a formatted decimal price without tax" do
                    expect(Store::Price.new(price: sku.price, tax_type: 'net').single).to eq '£22.67'
                end
            end

            context "if the args array does not have a 'net' string value" do
                let(:sku) { create(:sku, price: '283.67') }

                it "should return a formatted decimal price with tax" do
                    expect(Store::Price.new(price: sku.price).single).to eq '£340.40'
                end
            end
        end
    end

    describe "When rendering the range of a price for a view" do
        let!(:product) { create(:product, active: true) }
        let!(:sku) { create(:sku, price: '109.93', active: true, product_id: product.id) }
        let!(:sku_2) { create(:sku, active: true, product_id: product.id) }

        context "if the tax breakdown Store setting is true" do            
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: true, tax_name: 'VAT')
                Store.settings
            end

            it "should have the correct elements" do
                expect(Store::Price.new(price: sku.price, count: product.skus.count).range).to include("<span class='range-prefix'>from</span> #{Store::Price.new(price: sku.price, tax_type: 'net').single}")
                expect(Store::Price.new(price: sku.price, count: product.skus.count).range).to include("<span class=\"tax-suffix\">#{Store::Price.new(price: sku.price, tax_type: 'gross').single} inc VAT</span>")
            end
        end

        context "if the tax breakdown Store setting is false" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: false, tax_name: 'VAT')
                Store.settings
            end

            it "should have the correct elements" do
                expect(Store::Price.new(price: sku.price, count: product.skus.count).range).to include("<span class='range-prefix'>from</span> #{Store::Price.new(price: sku.price, tax_type: 'gross').single}")
                expect(Store::Price.new(price: sku.price, count: product.skus.count).range).to_not include("<span class='tax-suffix'>#{Store::Price.new(price: sku.price, tax_type: 'gross').single} inc VAT</span>")
            end
        end
    end

    describe "When rendering the markup of a price for a view" do
        let!(:sku) { create(:sku, price: '48.93') }

        context "if the tax breakdown Store setting is true" do
            before(:each) do
                Store::reset_settings
                StoreSetting.destroy_all
                create(:store_setting, tax_breakdown: true, tax_name: 'VAT')
                Store.settings
            end

            it "should have the correct elements" do
                expect(Store::Price.new(price: sku.price).markup).to include("<span class=\"tax-suffix\">#{Store::Price.new(price: sku.price, tax_type: 'gross').single} inc VAT</span>")
            end
        end

        context "if the tax breakdown Store setting is false" do

            it "should have the correct elements" do
                expect(Store::Price.new(price: sku.price).markup).to_not include("<span>#{Store::Price.new(price: sku.price).single}</span>")
            end
        end
    end
end