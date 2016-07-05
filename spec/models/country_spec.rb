# == Schema Information
#
# Table name: countries
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  popular        :boolean          default(FALSE)
#  alpha_two_code :string
#

require 'rails_helper'

describe Country do

    # ActiveRecord
    it { expect(subject).to have_many(:destinations).dependent(:destroy) }
    it { expect(subject).to have_many(:delivery_services).through(:destinations) }
    it { expect(subject).to have_many(:orders).through(:delivery_services) }
    it { expect(subject).to have_many(:products).through(:orders) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_uniqueness_of(:name) }
    it { expect(subject).to validate_presence_of(:alpha_two_code) }
    it { expect(subject).to validate_uniqueness_of(:alpha_two_code) }

    describe "When listing popular countries" do
        let!(:countries) { create_list(:country, 3, popular: true) }

        it "should return the correct list of countries" do
            expect(Country.popular.count).to eq 3
            expect(Country.popular).to eq countries
        end
    end

    describe "When listing unpopular countries" do
        let!(:countries) { create_list(:country, 5, popular: false) }

        it "should return the correct list of countries" do
            expect(Country.unpopular.count).to eq 5
            expect(Country.unpopular).to eq countries
        end
    end
end
