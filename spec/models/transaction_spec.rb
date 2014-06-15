require 'spec_helper'

describe Transaction do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:order) }

    # Validations
    it { expect(subject).to ensure_inclusion_of(:terms).in_array(%w('Completed', 'Pending')) }

end