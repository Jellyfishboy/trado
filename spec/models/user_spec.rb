require 'spec_helper'

describe User do

    # ActiveRecord relations
    it { expect(subject).to have_one(:attachment).dependent(:destroy) }
    it { expect(subject).to have_many(:notifications).dependent(:delete_all) }
    it { expect(subject).to have_many(:permissions).dependent(:delete_all) }
    it { expect(subject).to have_many(:roles).through(:permissions) }

    # Validations
    it { expect(subject).to validate_presence_of(:first_name) }
    it { expect(subject).to validate_presence_of(:last_name) }

    it { expect(subject).to accept_nested_attributes_for(:attachment) }

    describe "When querying a user's authentication level" do
        let(:admin) { create(:admin) }
        let(:user) { create(:standard_user) }

        it "should return true if the symbol parameter matches a role attached to the user" do
            expect(admin.role?(:admin)).to eq true
        end

        it "should return false if the symbol parameter doesn't match a role attached to the user" do
            expect(user.role?(:admin)).to eq false
        end
    end

    describe "When displaying a user's name" do
        let(:user) { create(:user, first_name: 'Tom', last_name: 'Dallimore') }

        it "should concatenate the user's first and last name to a string" do
            expect(user.full_name).to eq 'Tom Dallimore'
        end

    end
end