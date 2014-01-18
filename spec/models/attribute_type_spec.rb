require 'spec_helper'

describe AttributeType do

    # Validations
    it "is valid with name" do
        expect(build(:attribute_type)).to be_valid
    end
    it "is invalid without name" do
        attribute_type = build(:attribute_type, name: nil)
        expect(attribute_type).to have(1).errors_on(:name)
    end

end