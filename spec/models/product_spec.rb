# == Schema Information
#
# Table name: products
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  weighting         :integer
#  part_number       :integer
#  sku               :string
#  category_id       :integer
#  slug              :string
#  meta_description  :string
#  featured          :boolean
#  active            :boolean          default(TRUE)
#  short_description :text
#  status            :integer          default(0)
#  order_count       :integer          default(0)
#  page_title        :string
#

require 'rails_helper'

describe Product do

    # ActiveRecord relations
    it { expect(subject).to have_many(:skus).dependent(:destroy) }
    it { expect(subject).to have_many(:orders).through(:skus) }
    it { expect(subject).to have_many(:carts).through(:skus) }
    it { expect(subject).to have_many(:taggings).dependent(:destroy) }
    it { expect(subject).to have_many(:tags).through(:taggings) }
    it { expect(subject).to have_many(:attachments).dependent(:destroy) }
    it { expect(subject).to have_many(:accessorisations).dependent(:destroy) }
    it { expect(subject).to have_many(:accessories).through(:accessorisations) }
    it { expect(subject).to belong_to(:category) }


    # Validation
    context "When the product is being published" do

        it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:active) }
        it { expect(subject).to validate_uniqueness_of(:sku).scoped_to(:active) }
        it { expect(subject).to validate_uniqueness_of(:part_number).scoped_to(:active) }

        before { subject.stub(:published?) { true } }
        it { expect(subject).to validate_presence_of(:name) }
        it { expect(subject).to validate_presence_of(:meta_description) }
        it { expect(subject).to validate_presence_of(:description) }
        it { expect(subject).to validate_presence_of(:part_number) }
        it { expect(subject).to validate_presence_of(:sku) }
        it { expect(subject).to validate_presence_of(:category_id) }
        it { expect(subject).to validate_presence_of(:weighting) }

        it { expect(subject).to validate_numericality_of(:part_number).only_integer } 

        it { expect(subject).to validate_length_of(:name).is_at_least(10) }
        it { expect(subject).to validate_length_of(:page_title).is_at_most(70) }
        it { expect(subject).to validate_length_of(:meta_description).is_at_most(150) }
        it { expect(subject).to validate_length_of(:description).is_at_least(20) }
        it { expect(subject).to validate_length_of(:short_description).is_at_most(300) }
    end

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:skus) }
    it { expect(subject).to accept_nested_attributes_for(:attachments) }
    it { expect(subject).to accept_nested_attributes_for(:tags) }

    describe "Listing all products" do
        let!(:product_1) { create(:product) }
        let!(:product_2) { create(:product, active: true) }
        let!(:product_3) { create(:product, active: true) }

        it "should return an array of active products" do
            expect(Product.active).to match_array([product_2, product_3])
        end
    end

    describe "Default scope" do
        let!(:product_1) { create(:product, weighting: 2000) }
        let!(:product_2) { create(:product, weighting: 3000) }
        let!(:product_3) { create(:product, weighting: 1000) }

        it "should return an array of products ordered by descending weighting" do
            expect(Product.last(3)).to match_array([product_2, product_1, product_3])
        end
    end

    describe "Validating the product associated attachment count" do
        let!(:product) { build(:build_product_skus) }

        context "if the product has no associated attachments" do

            it "should produce an error" do
                product.valid?
                expect(product).to have(1).errors_on(:product)
                expect(product.errors.messages[:product]).to eq [" must have at least one attachment."]
            end
        end
    end

    describe "Validating the product associated SKU count" do
        let!(:product) { build(:build_product_attachment) }

        context "if the product has no associated SKUs" do

            it "should produce an error" do
                product.valid?
                expect(product).to have(1).errors_on(:product)
                expect(product.errors.messages[:product]).to eq [" must have at least one variant."]
            end
        end
    end

    describe 'Checking if a product has a single associated Sku' do

        context "if the product has one associated Sku" do
            let!(:product) { create(:product_sku, active: true) }

            it "should return true" do
                expect(product.single?).to eq true
            end
        end

        context "if the product has more than one associated Sku" do
            let!(:product) { create(:product_skus, active: true) }

            it "should return false" do
                expect(product.single?).to eq false
            end
        end
    end

    describe 'Find all associated variants by the variant_type parameter for a product' do
        let!(:product) { create(:product_sku, active: true) }
        let!(:weight_variant_type) { create(:variant_type, name: 'Weight') }
        let!(:color_variant_type) { create(:variant_type, name: 'Colour') }
        let!(:weight_variant_1) { create(:sku_variant, name:'500g', sku_id: product.skus.first.id, variant_type_id: weight_variant_type.id) }
        let!(:weight_variant_2) { create(:sku_variant, name: '1kg', sku_id: product.skus.first.id, variant_type_id: weight_variant_type.id) }

        before(:each) do
            create(:sku_variant, name: 'Red', sku_id: product.skus.first.id, variant_type_id: color_variant_type.id)
        end

        it "should return the correct list of variant names" do
            expect(product.variant_collection_by_type('Weight')).to match_array([weight_variant_1, weight_variant_2])
        end
    end

    describe 'Validating all Skus when a product is being published' do
        let!(:product) { create(:product_sku_attachment, active: true) }
        before(:each) do
            build(:invalid_sku, active: true, product_id: product.id).save(validate: false)
        end

        context "with invalid attributes" do

            it "should return an error" do
                product.valid?
                expect(product).to have(1).errors_on(:base)
                expect(product.errors.messages[:base]).to eq ["You must complete all variants before publishing the product."]
            end
        end
    end

    describe 'Checking if the product has any stock available in its active skus' do

        context "if the product has no stock" do
            let!(:product) { create(:product) }
            let!(:sku_1) { create(:sku, stock: 5, stock_warning_level: 1, product: product, active: true) }
            let!(:sku_2) { create(:sku, stock: 5, stock_warning_level: 1, product: product, active: true) }
            let!(:sku_3) { create(:sku, stock: 20, stock_warning_level: 1, product: product, active: false) }
            before(:each) do
                sku_1.update(stock: 0)
                sku_2.update(stock: 0)
            end

            it "should return false" do
                expect(product.in_stock?).to eq false
            end
        end

        context "if the product has stock" do
            let!(:product) { create(:product) }
            let!(:sku_1) { create(:sku, stock: 5, stock_warning_level: 1, product: product, active: true) }
            let!(:sku_2) { create(:sku, stock: 10, stock_warning_level: 1, product: product, active: true) }
            before(:each) do
                sku_2.update(stock: 0)
            end

            it "should return true" do
                expect(product.in_stock?).to eq true
            end
        end
    end
end
