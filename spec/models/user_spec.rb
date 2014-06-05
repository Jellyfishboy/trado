require 'spec_helper'

describe User do

    # ActiveRecord relations
    it { expect(subject).to have_one(:attachment).dependent(:destroy) }
    it { expect(subject).to have_many(:notifications).dependent(:delete_all) }
    it { expect(subject).to have_and_belong_to_many(:roles) }

    # Validations
    it { expect(subject).to validate_presence_of(:first_name) }
    it { expect(subject).to validate_presence_of(:last_name) }

    it { expect(subject).to accept_nested_attributes_for(:attachment) }
    
end