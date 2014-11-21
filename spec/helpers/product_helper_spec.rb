require 'rails_helper'

describe ProductHelper do

    store_setting

    describe '#sku_atttribute_values' do
        let!(:attribute_type) { create(:attribute_type) } 

        context "if the product is single" do
            let!(:product) { create(:product, active: true, single: false) }
            before(:each) do
                create(:sku, attribute_value: '55.4g', active: true, product_id: product.id, attribute_type_id: attribute_type.id)
            end

            it "should return a string" do
                expect(helper.sku_attribute_values(product.skus.first, product.single)).to eq "55.4g"
            end
        end

        context "if the product is not single" do
            let!(:product) { create(:product, active: true, single: true) }
            before(:each) do
                create(:sku, attribute_value: '55.4', active: true, product_id: product.id, attribute_type_id: attribute_type.id)
            end

            it "should return nil" do
                expect(helper.sku_attribute_values(product.skus.first, product.single)).to eq nil
            end
        end
    end

    describe '#accessory_details' do
        let(:accessory) { create(:accessory, name: 'Accessory #1', price: '8.67') }
        let(:store_setting) { create(:store_setting, tax_breakdown: false) }
        before(:each) do
            Store::reset_settings
            StoreSetting.destroy_all
            store_setting
            Store::settings
        end

        it "should return a html_safe string" do
            expect(helper.accessory_details(accessory)).to eq 'Accessory #1 (+£10.40)'
        end
    end

    describe '#product_filter_classes' do

        context "if the product has a category" do
            let!(:category) { create(:category) }
            let(:product) { create(:product, active: true, category_id: category.id) }

            it "should return a string of classes, including product category name" do
                expect(product_filter_classes(product)).to eq "product-#{product.status} category-#{product.category.slug}"
            end
        end

        context "if the product is set to featured" do
            let(:product) { create(:product, active: true, featured: true, category_id: nil) }

            it "should return a string of classes, including 'product-featured'" do
                expect(product_filter_classes(product)).to eq "product-#{product.status} product-featured"
            end
        end

        context "if the product has no category and is not set to featured" do
            let(:product) { create(:product, category_id: nil) }

            it "should return a only the product-status class" do
                expect(product_filter_classes(product)).to eq "product-#{product.status}"
            end
        end
    end
end