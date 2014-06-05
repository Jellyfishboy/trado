require 'spec_helper'

describe Sku do

    # ActiveRecord relations
    it { expect(subject).to have_many(:cart_items) }
    it { expect(subject).to have_many(:carts).through(:cart_items) }
    it { expect(subject).to have_many(:order_items).dependent(:restrict) }
    it { expect(subject).to have_many(:orders).through(:order_items).dependent(:restrict) }
    it { expect(subject).to have_many(:notifications).dependent(:delete_all) }
    it { expect(subject).to have_many(:stock_levels).dependent(:delete_all) }
    it { expect(subject).to belong_to(:product) }
    it { expect(subject).to belong_to(:attribute_type) }

    # Validation
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:cost_value) }
    it { expect(subject).to validate_presence_of(:length) }
    it { expect(subject).to validate_presence_of(:weight) }
    it { expect(subject).to validate_presence_of(:thickness) }
    it { expect(subject).to validate_presence_of(:attribute_value) }
    it { expect(subject).to validate_presence_of(:attribute_type_id) }
    it { expect(subject).to validate_presence_of(:code) }
    it { expect(subject).to validate_presence_of(:stock) }
    it { expect(subject).to validate_presence_of(:stock_warning_level) }

    it { expect(subject).to validate_numericality_of(:length).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:weight).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:thickness).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:stock).is_greater_than_or_equal_to(1).only_integer } 
    it { expect(subject).to validate_numericality_of(:stock_warning_level).is_greater_than_or_equal_to(1).only_integer }

    it { expect(create(:sku)).to validate_uniqueness_of(:attribute_value).scoped_to([:product_id, :active]) }
    # before { subject.stub(:new_sku?) { true } }
    it { expect(subject).to validate_uniqueness_of(:code).scoped_to([:product_id, :active]) }

    describe "When creating a new SKU" do
        let!(:sku) { build(:sku, stock: 5, stock_warning_level: 10) }
        
        it "should validate whether the stock value is higher than stock_warning_level" do
            expect(sku).to have(1).error_on(:sku)
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
        let(:product) { create(:product_sku, sku: 'GA280') }

        it "should return a string value of the product SKU and the child SKU joined by a hyphen" do
            expect(product.skus.first.full_sku).to eq 'GA280-55'
        end
    end

end