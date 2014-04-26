require 'spec_helper'

describe Country do

    # ActiveRecord
    it { expect(subject).to have_many(:zonifications).dependent(:delete_all) }
    it { expect(subject).to have_many(:zones).through(:zonifications) }
    it { expect(subject).to have_one(:country_tax).class_name('CountryTax').dependent(:destroy) }
    it { expect(subject).to have_one(:tax).through(:country_tax).source(:tax_rate) }

    #Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:iso) }
    it { expect(subject).to validate_presence_of(:language) }
    it { expect(subject).to validate_uniqueness_of(:name) }
    it { expect(subject).to validate_uniqueness_of(:iso) }

    describe "Default scope" do
        let!(:country_1) { create(:country, name: 'United Kingdom') }
        let!(:country_2) { create(:country, name: 'Belgium') }
        let!(:country_3) { create(:country, name: 'Zimbabwe') }
        
        it "should return an array of countries in alphabetical order" do
            expect(Country.all).to match_array([country_2, country_1, country_3])
        end
    end

    describe "Listing all SKUs" do
        let!(:country_1) { create(:country, available: true) }
        let!(:country_2) { create(:country) }
        let!(:country_3) { create(:country, available: true) }

        it "should return an array of 'available' countries" do
            expect(Country.available).to match_array([country_1, country_3])
        end
    end

end