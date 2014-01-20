require 'spec_helper'

describe Category do

    # ActiveRecord relations
    it { expect(subject).to have_many(:products) }

    #Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:description) }

    it { expect(subject).to validate_uniqueness_of(:name) }
    
end