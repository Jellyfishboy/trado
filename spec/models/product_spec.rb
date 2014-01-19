require 'spec_helper'

describe Product do

    # Validation
    it "is valid with name, meta description, description, part number, sku and weighting" do
        expect(build(:product)).to be_valid
    end
    it "is invalid without a name" do
        product = build(:product, name: nil)
        expect(product).to have(2).errors_on(:name)
    end
    it "is invalid without a meta description" do
        product = build(:product, meta_description: nil)
        expect(product).to have(2).errors_on(:meta_description)
    end
    it "is invalid without a description" do
        product = build(:product, description: nil)
        expect(product).to have(2).errors_on(:description)
    end
    it "is invalid without a part number" do
        product = build(:product, part_number: nil)
        expect(product).to have(2).errors_on(:part_number)
    end
    it "is invalid without a sku" do
        product = build(:product, sku: nil)
        expect(product).to have(1).errors_on(:sku)
    end
    it "is invalid without a weighting" do
        product = build(:product, weighting: nil)
        expect(product).to have(2).errors_on(:weighting)
    end
    it "is valid with a unique part number, sku and name" do
        create(:product, part_number: 123, sku: 'GLA750', name: 'Product #1')
        product = build(:product, part_number: 124, sku: 'GLA749', name: 'Product #2')
        expect(product).to be_valid
    end
    it "is invalid without a unique part number" do
        create(:product, part_number: 124)
        product = build(:product, part_number: 124)
        expect(product).to have(1).errors_on(:part_number)
    end
    it "is invalid without a unique sku" do
        create(:product, sku: 'GLA750')
        product = build(:product, sku: 'GLA750')
        expect(product).to have(1).errors_on(:sku)
    end
    it "is invalid without a unique name" do
        create(:product, name: 'Product #1')
        product = build(:product, name: 'Product #1')
        expect(product).to have(1).errors_on(:name)
    end
    it "is valid with an integer part nunber and weighting" do
        product = build(:product)
        expect(product.part_number).to be_kind_of(Integer)
        expect(product.weighting).to be_kind_of(Integer)
        expect(build(:product)).to be_valid
    end
    it "is invalid with a non integer part number" do
        product = build(:product, part_number: 'string')
        expect(product).to have(1).errors_on(:part_number)
    end
    it "is invalid with a non integer weighting" do
        product = build(:product, weighting: 'string')
        expect(product).to have(1).errors_on(:weighting)
    end
    it "is valid when part number and weighting is equal to or more than one" do
        product = build(:product, part_number: 1, weighting: 1)
        expect(product).to be_valid
    end
    it "is invalid with a part number less than one" do
        product = build(:product, part_number: 0)
        expect(product).to have(1).errors_on(:part_number)
    end
    it "is invalid with a weighting less than one" do
        product = build(:product, weighting: 0)
        expect(product).to have(1).errors_on(:weighting)
    end
    it "is valid with 10 or more characters in the name and meta description" do
        product = build(:product)
        expect(product.name).to have(10).characters
        expect(product.meta_description).to have(10).characters
        expect(product).to be_valid
    end
    it "is invalid with less than 10 characters in the name" do
        product = build(:product, name: 'Telephone')
        expect(product.name).to have(9).characters
        expect(product).to have(1).errors_on(:name)
    end
    it "is valid with 20 or more characters in the description" do
        product = build(:product)
        expect(product.description).to have(20).characters
        expect(product).to be_valid
    end
    it "is invalid with less than 20 characters in the description" do
        product = build(:product, description: 'Product information')
        expect(product.description).to have(19).characters
        expect(product).to have(1).errors_on(:description)
    end

end