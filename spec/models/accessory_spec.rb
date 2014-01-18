require 'spec_helper'

describe Accessory do

    # Validations
    it "is valid with a name and part number" do
        expect(build(:accessory)).to be_valid
    end
    it "it is invalid without a name" do
        accessory = build(:accessory, name: nil)
        expect(accessory).to have(1).errors_on(:name)
    end
    it "it is invalid without a part number" do
        accessory = build(:accessory, part_number: nil)
        expect(accessory).to have(2).errors_on(:part_number)
    end
    it "is valid with an integer part nunber" do
        expect(build(:accessory)).to be_valid
    end
    it "is invalid with a non integer part number" do
        accessory = build(:accessory, part_number: 'string')
        expect(accessory).to have(1).errors_on(:part_number)
    end
    it "is valid when part number is equal to or more than one" do
        accessory = build(:accessory, part_number: 1)
        expect(accessory).to be_valid
    end
    it "is invalid with a part number less than one" do
        accessory = build(:accessory, part_number: 0)
        expect(accessory).to have(1).errors_on(:part_number)
    end
    it "is valid with a unique name" do
        create(:accessory, name: 'accessory1')
        accessory = build(:accessory, name: 'accessory2')
        expect(accessory).to be_valid
    end
    it "is invalid with a non unique name" do
        create(:accessory, name: 'accessory1')
        accessory = build(:accessory, name: 'accessory1')
        expect(accessory).to have(1).errors_on(:name)
    end
    it "is valid with a unique part number" do
        create(:accessory, part_number: 123)
        accessory = build(:accessory, name: 124)
        expect(accessory).to be_valid
    end
    it "is invalid without a unique part number" do
        create(:accessory, part_number: 123)
        accessory = build(:accessory, part_number: 123)
        expect(accessory).to have(1).errors_on(:part_number)
    end

end