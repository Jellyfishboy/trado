require 'rails_helper'

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
                expect(Store::positive?(5)).to eq true
            end
        end

        context "if its a negative value" do

            it "should return false" do
                expect(Store::positive?(-50)).to eq false
            end
        end
    end

    describe "When a redundant record is updated or deleted" do
        let(:product) { create(:product, active: true) }

        it "should set the record as inactive" do
            Store::inactivate!(product)
            expect(product.active).to eq false
        end
    end

    describe "When archiving child records" do
        let!(:product) { create(:product) }
        let!(:skus) { create_list(:sku, 3, product_id: product.id) }

        it "should set all the records as inactive" do
            Store::inactivate_all!(product.skus)
            expect(product.skus.pluck(:active)).to eq [false, false, false]
        end
    end

    describe "When the record fails to update" do
        let(:product) { create(:product) }

        it "should set the record as active" do
            Store::activate!(product)
            expect(product.active).to eq true
        end
    end

    describe "When rendering an object's parent class name" do
        let(:attribute_type) { create(:attribute_type) }

        it "should return a string" do
            expect(Store::class_name(attribute_type)).to eq 'Attribute Type'
        end
    end

    describe "When deleting a record" do

        context "if it is the last record" do
            let!(:category) { create(:category) }

            it "should return a failed string message" do
                expect(Store::last_record(category, Category.all.count)).to match_array([:error, 'Failed to delete category - you must have at least one.'])
            end

            it "should not delete the record" do
                expect{
                    Store::last_record(category, Category.all.count)
                }.to change(Category, :count).by(0)
            end
        end

        context "if it is not the last record" do
            let!(:category) { create_list(:category, 3) }

            it "should return a success string message" do
                expect(Store::last_record(category.first, Category.all.count)).to match_array([:success, 'Category was successfully deleted.'])
            end
            it "should delete the record" do
                expect{
                    Store::last_record(category.first, Category.all.count)
                }.to change(Category, :count).by(-1)
            end
        end
    end
end