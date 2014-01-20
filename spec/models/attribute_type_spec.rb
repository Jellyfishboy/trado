require 'spec_helper'

describe AttributeType do

    # ActiveRecord relations
    it { expect(subject).to have_many(:skus) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }

end