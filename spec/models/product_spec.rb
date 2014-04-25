require 'spec_helper'

describe Product do

    # ActiveRecord relations
    it { expect(subject).to have_many(:skus).dependent(:delete_all) }
    it { expect(subject).to have_many(:orders).through(:skus) }
    it { expect(subject).to have_many(:carts).through(:skus) }
    it { expect(subject).to have_many(:taggings).dependent(:delete_all) }
    it { expect(subject).to have_many(:tags).through(:taggings) }
    it { expect(subject).to have_many(:attachments).dependent(:delete_all) }
    it { expect(subject).to have_many(:accessorisations).dependent(:delete_all) }
    it { expect(subject).to have_many(:accessories).through(:accessorisations) }
    it { expect(subject).to belong_to(:category) }


    # Validation
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:meta_description) }
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:part_number) }
    it { expect(subject).to validate_presence_of(:sku) }
    it { expect(subject).to validate_presence_of(:category_id) }
    it { expect(subject).to validate_presence_of(:weighting) }

    it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:active) }
    it { expect(subject).to validate_uniqueness_of(:sku).scoped_to(:active) }
    it { expect(subject).to validate_uniqueness_of(:part_number).scoped_to(:active) }

    it { expect(subject).to ensure_length_of(:name).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:meta_description).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:description).is_at_least(20) }
    it { expect(subject).to ensure_length_of(:short_description).is_at_most(100) }

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:skus) }
    it { expect(subject).to accept_nested_attributes_for(:attachments) }
    it { expect(subject).to accept_nested_attributes_for(:tags) }

    describe "When a used product is updated or deleted" do
        let(:product) { create(:product, active: true) }

        it "should set the record as inactive" do
            product.inactivate!
            expect(product.active).to eq false
        end
    end

    describe "When the product fails to update" do
        let(:product) { create(:product) }

        it "should set the record as active" do
            product.activate!
            expect(product.active).to eq true
        end
    end

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

    describe "Setting a product as a single product" do

        context "when the product has more than one SKUs" do

            it "should produce an error"
        end
    end
    
end
