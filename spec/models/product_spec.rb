require 'spec_helper'

describe Product do

    # ActiveRecord relations
    it { expect(subject).to have_many(:skus).dependent(:delete_all) }
    it { expect(subject).to have_many(:orders).through(:skus) }
    it { expect(subject).to have_many(:carts).through(:skus) }
    it { expect(subject).to have_many(:taggings).dependent(:delete_all) }
    it { expect(subject).to have_many(:tags).through(:taggings) }
    it { expect(subject).to have_many(:attachments).dependent(:delete_all) }
    it { expect(subject).to belong_to(:category) }


    # Validation
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:meta_description) }
    it { expect(subject).to validate_presence_of(:short_description) }
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:part_number) }
    it { expect(subject).to validate_presence_of(:sku) }

    it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:active) }
    it { expect(subject).to validate_uniqueness_of(:sku).scoped_to(:active) }
    it { expect(subject).to validate_uniqueness_of(:part_number).scoped_to(:active) }

    it { expect(subject).to validate_numericality_of(:part_number).only_integer }
    it { expect(subject).to validate_numericality_of(:part_number).is_greater_than_or_equal_to(1) }

    it { expect(subject).to ensure_length_of(:name).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:meta_description).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:description).is_at_least(20) }

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:skus) }
    it { expect(subject).to accept_nested_attributes_for(:attachments) }
    it { expect(subject).to accept_nested_attributes_for(:tags) }

    context "When a used product is updated or deleted" do

        it "should set the record as inactive" do
            product = create(:product)
            product.inactivate!
            expect(product.active).to eq false
        end
    end

    context "When the new SKU fails to update" do

        it "should set the record as active" do
            sku = create(:sku, active: false)
            sku.activate!
            expect(sku.active).to eq true
        end
    end

    it "should return an array of active products" do
        product_1 = create(:product, active: false)
        product_2 = create(:product)
        product_3 = create(:product)
        expect(Product.active).to match_array([product_2, product_3])
    end
    
end
