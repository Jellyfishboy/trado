# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  company          :string
#  address          :string
#  city             :string
#  county           :string
#  postcode         :string
#  country          :string
#  telephone        :string
#  active           :boolean          default(TRUE)
#  default          :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  addressable_id   :integer
#  addressable_type :string
#  order_id         :integer
#

require 'rails_helper'

describe Address do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:order) }
    it { expect(subject).to belong_to(:addressable) }
    
    # Validations
    it { expect(create(:address)).to validate_presence_of(:first_name) }
    it { expect(create(:address)).to validate_presence_of(:last_name) }
    it { expect(create(:address)).to validate_presence_of(:address) }
    it { expect(create(:address)).to validate_presence_of(:city) }
    it { expect(create(:address)).to validate_presence_of(:postcode) }

    describe "When displaying an address" do
        let!(:address) { create(:address, first_name: 'John', last_name: 'Doe') }

        it "should return a contact's full name as a string" do
            expect(address.full_name).to eq 'John Doe'
        end
    end

    describe "When display a full address" do
        let!(:address) { create(:address, first_name: 'John', last_name: 'Doe', address: '12 New St', telephone: '0123712963872') }
        let!(:full_address_hash) {
            {
                name: 'John Doe',
                address1: '12 New St',
                city: address.city,
                zip: address.postcode,
                state: address.county,
                country: address.country.alpha_two_code,
                telephone: '0123712963872'
            }
        }

        it "should return a hash of the full address" do
            expect(address.full_address).to eq full_address_hash
        end
    end
end
