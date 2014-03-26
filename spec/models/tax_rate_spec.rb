require 'spec_helper'

describe TaxRate do
    
    # ActiveRecord relations
    it { expect(subject).to have_many(:countries) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:rate) }
    it { expect(subject).to validate_uniqueness_of(:name) }
    
end
