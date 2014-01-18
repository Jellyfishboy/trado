require 'spec_helper'

describe Address do
    
    # Validations
    it "is valid with first name, last name, address, city, postcode and country" do
        expect(build(:address)).to be_valid
    end
    it "is invalid without a first name" do
        address = build(:address, first_name: nil)
        expect(address).to have(1).errors_on(:first_name)
    end
    it "is invalid without a last name" do
        address = build(:address, last_name: nil)
        expect(address).to have(1).errors_on(:last_name)
    end
    it "is invalid without an address" do
        address = build(:address, address: nil)
        expect(address).to have(1).errors_on(:address)
    end
    it "is invalid without a city" do
        address = build(:address, city: nil)
        expect(address).to have(1).errors_on(:city)
    end
    it "is invalid without a postcode" do
        address = build(:address, postcode: nil)
        expect(address).to have(1).errors_on(:postcode)
    end
    it "is invalid without a country" do
        address = build(:address, country: nil)
        expect(address).to have(1).errors_on(:country)
    end
    
end