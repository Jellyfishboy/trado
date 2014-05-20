require 'spec_helper'

describe Category do

    # ActiveRecord relations
    it { expect(subject).to have_many(:products) }

    #Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:sorting) }

    it { expect(subject).to validate_numericality_of(:sorting).is_greater_than_or_equal_to(0).only_integer } 

    it { expect(subject).to validate_uniqueness_of(:name) }
    it { expect(subject).to validate_uniqueness_of(:sorting) }
    
end