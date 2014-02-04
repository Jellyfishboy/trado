require 'spec_helper'

describe Address do
    
    # Validations
    it { expect(subject).to validate_presence_of(:first_name) }
    it { expect(subject).to validate_presence_of(:last_name) }
    it { expect(subject).to validate_presence_of(:address) }
    it { expect(subject).to validate_presence_of(:city) }
    it { expect(subject).to validate_presence_of(:postcode) }
    it { expect(subject).to validate_presence_of(:country) }


    it "should return a contact's full name as a string" do
        address = create(:address, first_name: 'John', last_name: 'Doe')
        expect(address.full_name).to eq 'John Doe'
    end
    
end