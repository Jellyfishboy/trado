require 'rails_helper'

describe Sku do

    # ActiveRecord relations
    it { expect(subject).to have_many(:cart_items) }
    it { expect(subject).to have_many(:carts).through(:cart_items) }
    it { expect(subject).to have_many(:order_items).dependent(:restrict_with_exception) }
    it { expect(subject).to have_many(:orders).through(:order_items).dependent(:restrict_with_exception) }
    it { expect(subject).to have_many(:notifications).dependent(:delete_all) }
    it { expect(subject).to have_many(:stock_adjustments).dependent(:delete_all) }
    it { expect(subject).to have_one(:category).through(:product) }
    it { expect(subject).to belong_to(:product) }
    it { expect(subject).to belong_to(:attribute_type) }

    # Validation
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:cost_value) }
    it { expect(subject).to validate_presence_of(:length) }
    it { expect(subject).to validate_presence_of(:weight) }
    it { expect(subject).to validate_presence_of(:thickness) }
    it { expect(subject).to validate_presence_of(:code) }
    it { expect(subject).to validate_presence_of(:stock) }
    it { expect(subject).to validate_presence_of(:stock_warning_level) }

    context "When the skus parent product has more than one sku" do
        before { subject.stub(:not_single_sku?) { true } }
        it { expect(subject).to validate_presence_of(:attribute_value) }
        it { expect(subject).to validate_presence_of(:attribute_type_id) }
    end

    it { expect(subject).to validate_numericality_of(:length).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:weight).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:thickness).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:stock).is_greater_than_or_equal_to(1).only_integer } 
    it { expect(subject).to validate_numericality_of(:stock_warning_level).is_greater_than_or_equal_to(1).only_integer }

    it { expect(create(:sku)).to validate_uniqueness_of(:attribute_value).scoped_to([:product_id, :active]) }
    it { expect(subject).to validate_uniqueness_of(:code).scoped_to([:product_id, :active]) }


    describe "Default scope" do
        let!(:sku_1) { create(:sku, code: 200) }
        let!(:sku_2) { create(:sku, code: 101) }
        let!(:sku_3) { create(:sku, code: 55) }

        it "should return an array of skus ordered by ascending code" do
            expect(Sku.last(3)).to match_array([sku_3, sku_2, sku_1])
        end
    end

    describe "When creating a new SKU" do
        let!(:sku) { build(:sku, stock: 5, stock_warning_level: 10) }
        let(:create_sku) { create(:sku_after_stock_adjustment, stock: 55) }
        
        it "should validate whether the stock value is higher than stock_warning_level" do
            expect(sku).to have(1).error_on(:sku)
            expect(sku.errors.messages[:sku]).to eq ["stock warning level value must not be below your stock count."]
        end

        it "should create a new stock level record" do
            expect{
                create_sku
            }.to change(StockAdjustment, :count).by(1)
        end

        it "should set the stock level record as 'Initial stock'" do
            create_sku
            expect(create_sku.stock_adjustments.first.description).to eq 'Initial stock'
        end

        it "should set the stock level record adjustment as the SKU's stock" do
            create_sku
            expect(create_sku.stock_adjustments.first.adjustment).to eq 55
        end
    end

    describe "Listing all SKUs" do
        let!(:sku_1) { create(:sku) }
        let!(:sku_2) { create(:sku, active: true) }
        let!(:sku_3) { create(:sku) }

        it "should return an array of active SKUs" do
            expect(Sku.active).to match_array([sku_2])
        end
    end

    describe "Displaying a full SKU value" do
        let(:product) { create(:product_sku, sku: 'GA180') }

        it "should return a string value of the product SKU and the child SKU joined by a hyphen" do
            product.reload
            expect(product.skus.first.full_sku).to eq 'GA180-55'
        end
    end

    describe "When creating or updating a product" do

        context "if the product has a one SKU and it's single_product field is set to true" do
            let!(:product) { create(:product_sku, single: true) }

            it "should return false for attribute validation" do
                product.reload
                expect(product.skus.first.not_single_sku?).to eq false
            end
        end

        context "if the product has more than one SKU and/or it's single_product field is set to false" do
            let!(:product) { create(:product_skus, single: false) }

            it "should return true for attribute validation" do
                product.reload
                expect(product.skus.first.not_single_sku?).to eq true
            end
        end
    end

    describe "After updating a SKU" do
        let!(:sku) { create(:sku, weight: '2.4') }
        let!(:cart_item) { create(:cart_item, quantity: 4, weight: '9.6', sku: sku) }

        it "should update the associated cart_item records weight" do
            expect(cart_item.weight).to eq BigDecimal.new("9.6")
            sku.update(:weight => '4.4')
            cart_item.reload
            expect(cart_item.weight).to eq BigDecimal.new("17.6")
        end
    end
end