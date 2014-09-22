require 'rails_helper'

describe Tagging do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:tag) }
    it { expect(subject).to belong_to(:product) }

    # Validations
    it { expect(subject).to validate_uniqueness_of(:tag_id).scoped_to(:product_id) }
end