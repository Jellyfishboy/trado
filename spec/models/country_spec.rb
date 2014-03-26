require 'spec_helper'

describe Country do

    # ActiveRecord
    it { expect(subject).to have_many(:zonifications).dependent(:delete_all) }
    it { expect(subject).to have_many(:zones).through(:zonifications) }
    it { expect(subject).to belong_to(:tax_rate) }

    #Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_uniqueness_of(:name) }

    describe "Default scope" do
        
        it "should return an array of countries in alphabetical order" do
            country_1 = create(:country, name: 'United Kingdom')
            country_2 = create(:country, name: 'Belgium')
            country_3 = create(:country, name: 'Zimbabwe')
            expect(Country.all).to match_array([country_2, country_1, country_3])
        end
    end

end