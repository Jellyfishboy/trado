require 'spec_helper'

describe Notification do

    #Validations
    it "is valid with an email" do
        expect(build(:notification)).to be_valid
    end
    it "is invalid without an email" do
        notification = build(:notification, email: nil)
        expect(notification).to have(2).errors_on(:email)
    end
    it "is valid with a valid email" do
        expect(build(:notification)).to be_valid
    end
    it "is invalid without a valid email" do
        notification = build(:notification, email: Faker::Lorem.word)
        expect(notification).to have(1).errors_on(:email)
    end
    it "it is valid with a unique email" do
        create(:notification, email: 'joe@test.com')
        notification = build(:notification, email: 'tim@test.com')
        expect(notification).to be_valid
    end
    it "it is invalid without a unique email" do
        create(:notification, email: 'joe@test.com')
        notification = build(:notification, email: 'joe@test.com')
        expect(notification).to have(1).errors_on(:email)
    end

end