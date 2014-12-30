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
    it { expect(subject).to have_many(:variants).dependent(:delete_all).class_name('SkuVariant') }
    it { expect(subject).to have_many(:variant_types).through(:variants) }

    # Validation
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:cost_value) }
    it { expect(subject).to validate_presence_of(:length) }
    it { expect(subject).to validate_presence_of(:weight) }
    it { expect(subject).to validate_presence_of(:thickness) }
    it { expect(subject).to validate_presence_of(:code) }

    it { expect(subject).to validate_numericality_of(:length).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:weight).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:thickness).is_greater_than_or_equal_to(0) } 

    before { subject.stub(:new_record?) { true } }
    it { expect(subject).to validate_presence_of(:stock) }
    it { expect(subject).to validate_presence_of(:stock_warning_level) }
    it { expect(subject).to validate_numericality_of(:stock).is_greater_than_or_equal_to(1).only_integer } 
    it { expect(subject).to validate_numericality_of(:stock_warning_level).is_greater_than_or_equal_to(1).only_integer }    

    it { expect(subject).to validate_uniqueness_of(:code).scoped_to([:product_id, :active]) }

    describe "When creating a new SKU" do
        let!(:sku) { build(:sku, stock: 5, stock_warning_level: 10) }
        let(:create_sku) { create(:sku_after_stock_adjustment, stock: 55) }
        
        it "should validate whether the stock value is higher than stock_warning_level" do
            expect(sku).to have(1).error_on(:sku)
            expect(sku.errors.messages[:sku]).to eq ["stock warning level value must not be below your stock count."]
        end

        it "should create a new stock adjustment record" do
            expect{
                create_sku
            }.to change(StockAdjustment, :count).by(1)
        end

        it "should set the stock adjustment record as 'Initial stock'" do
            create_sku
            expect(create_sku.stock_adjustments.first.description).to eq 'Initial stock'
        end

        it "should set the stock adjustment record adjustment as the SKU's stock" do
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

    describe 'Checking if a sku has any associated stock adjustment records' do
        

        context "if the sku has associated stock adjustment records" do
            let!(:sku) { create(:sku_after_stock_adjustment, active: true) }

            it "should return false" do
                expect(sku.no_stock_adjustments?).to eq false
            end
        end

        context "if the sku does not have any associated stock adjustments record" do
            let!(:sku) { create(:sku, active: true) }

            it "should return true" do
                expect(sku.no_stock_adjustments?).to eq true
            end
        end
    end

    describe 'Validation variant duplication' do
        let!(:sku) { create(:sku, active: true) }

        context "if the associated sku variants have any nil name attributes" do
            before(:each) do
                build(:sku_variant, name: nil, sku_id: sku.id)
            end

            it "should return false" do
                expect(sku.variant_duplication).to eq false
            end
        end

        context "if the sku has no associated variants" do

            it "should return false" do
                expect(sku.variant_duplication).to eq false
            end
        end

        context "if the assocaited sku variants has a duplicated name" do
            let!(:product) { create(:product, active: true) }
            let!(:old_sku) { create(:sku, active: true, product_id: product.id) }
            let!(:sku) { create(:sku, active: true, product_id: product.id) }
            let!(:weight_variant_type) { create(:variant_type, name: 'Weight') }
            let!(:color_variant_type) { create(:variant_type, name: 'Colour') }

            before(:each) do
                create(:sku_variant, name: '500g', variant_type_id: weight_variant_type.id, sku_id: old_sku.id)
                create(:sku_variant, name: 'Blue', variant_type_id: weight_variant_type.id, sku_id: old_sku.id)
                create(:sku_variant, name: '500g', variant_type_id: color_variant_type.id, sku_id: sku.id)
                create(:sku_variant, name: 'Blue', variant_type_id: color_variant_type.id, sku_id: sku.id)
            end

            it "should return an error message" do
                sku.reload
                sku.valid?
                expect(sku).to have(1).error_on(:base)
                expect(sku.errors.messages[:base]).to eq ["Variants combination already exists."]
            end
        end
    end

    describe 'Checking if the product has more than one associated Sku' do

        context "if the product has more than one associated Sku" do
            let!(:product) { create(:product_skus, active: true) }

            it "should return false" do
                expect(product.skus.first.last_active_sku?).to eq false
            end
        end

        context "if the product has only one associated Sku" do
            let!(:product) { create(:product_sku, active: true) }

            it "should return true" do
                expect(product.skus.first.last_active_sku?).to eq true
            end
        end
    end
end