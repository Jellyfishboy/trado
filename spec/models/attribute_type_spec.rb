require 'rails_helper'

describe AttributeType do

    # ActiveRecord relations
    it { expect(subject).to have_many(:skus).dependent(:restrict_with_exception) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }

end