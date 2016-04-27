require 'rails_helper'

describe Country do

    # ActiveRecord
    it { expect(subject).to have_many(:destinations).dependent(:destroy) }
    it { expect(subject).to have_many(:delivery_services).through(:destinations) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_uniqueness_of(:name) }

    describe "Default scope" do
        let!(:country_1) { create(:country, name: 'United Kingdom') }
        let!(:country_2) { create(:country, name: 'Belgium') }
        let!(:country_3) { create(:country, name: 'Zimbabwe') }
        
        it "should return an array of countries in alphabetical order" do
            expect(Country.all).to match_array([country_2, country_1, country_3])
        end
    end
end