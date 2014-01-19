require 'spec_helper'

describe Shipping do

    # Validations
    it "is valid with name, price and description" do
        expect(build(:shipping)).to be_valid
    end
    it "is invalid without a name" do
        shipping = build(:shipping, name: nil)
        expect(shipping).to have(2).errors_on(:name)
    end
    it "is invalid without a price" do
        shipping = build(:shipping, price: nil)
        expect(shipping).to have(2).errors_on(:price)
    end
    it "is invalid without a description" do
        shipping = build(:shipping, description: nil)
        expect(shipping).to have(1).errors_on(:description)
    end
    it "is valid with a unique name" do
        create(:shipping, name: 'Royal Mail')
        shipping = build(:shipping, name: 'Parcelforce')
        expect(shipping).to be_valid
    end
    it "is invalid without a unique name" do
        create(:shipping, name: 'Royal Mail')
        shipping = build(:shipping, name: 'Royal Mail')
        expect(shipping).to have(1).errors_on(:name)
    end
    it "is valid with 10 or more characters in the name" do
        expect(build(:shipping).name).to have(10).characters
        expect(build(:shipping)).to be_valid
    end
    it "is invalid with less than 10 characters in the name" do
        shipping = build(:shipping, name: 'Postage')
        expect(shipping.name).to have(7).characters
        expect(shipping).to have(1).errors_on(:name)
    end
    it "is valid with a less than 100 characters in the description" do
        expect(build(:shipping).description).to have(99).characters
        expect(build(:shipping)).to be_valid
    end
    it "is invalid with more than 100 characters in the description" do
        shipping = build(:shipping, description: Faker::Lorem.characters(101))
        expect(shipping.description).to have(101).characters
        expect(shipping).to have(1).errors_on(:description)
    end

end