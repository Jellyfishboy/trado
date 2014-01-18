require 'spec_helper'

describe Category do

    #Validations
    it "is valid with name and description" do
        expect(build(:category)).to be_valid
    end
    it "is invalid without a name" do
        category = build(:category, name: nil)
        expect(category).to have(1).errors_on(:name)
    end
    it "is invalid without a description" do
        category = build(:category, description: nil)
        expect(category).to have(1).errors_on(:description)
    end
    it "is valid with a unique name" do
        create(:category, name: 'E-commerce')
        category = build(:category, name: 'Engineering')
        expect(category).to be_valid
    end
    it "is invalid without a unique name" do
        create(:category, name: 'E-commerce')
        category = build(:category, name: 'E-commerce')
        expect(category).to have(1).errors_on(:name)
    end
end