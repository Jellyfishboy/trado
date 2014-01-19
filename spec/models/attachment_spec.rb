require 'spec_helper'

describe Attachment do

    # Validations
    it "is valid with file and description" do
        expect(build(:attachment)).to be_valid
    end
    it "is invalid without a file" do
        attachment = build(:attachment, file: nil)
        expect(attachment).to have(2).errors_on(:file)
    end
    it "is invalid without a description" do
        attachment = build(:attachment, description: nil)
        expect(attachment).to have(2).errors_on(:description)
    end
    it "is valid with 5 or more characters in the description" do
        expect(build(:attachment).description).to have(5).characters
        expect(build(:attachment)).to be_valid
    end
    it "is invalid with less than 5 characters in the description" do
        attachment = build(:attachment, description: 'hehe')
        expect(attachment.description).to have(4).characters
        expect(attachment).to have(1).errors_on(:description)
    end

end