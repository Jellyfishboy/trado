require 'spec_helper'

describe Country do

    #Validations
    it "is valid with name" do
        expect(build(:country)).to be_valid
    end
    it "is invalid without a name" do
        country = build(:country, name: nil)
        expect(country).to have(1).errors_on(:name)
    end
    it "is valid with a unqiue name" do
        create(:country, name: 'United Kingdom')
        country = build(:country, name: 'United States')
        expect(country).to be_valid
    end
    it "is invalid without a unique name" do
        create(:country, name: 'United Kingdom')
        country = build(:country, name: 'United Kingdom')
        expect(country).to have(1).errors_on(:name)
    end

end