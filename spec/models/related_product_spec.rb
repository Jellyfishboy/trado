require 'spec_helper'

describe RelatedProduct do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:product) }

    # Validations
    it { expect(subject).to validate_uniqueness_of(:related_id).scoped_to(:product_id) }

end