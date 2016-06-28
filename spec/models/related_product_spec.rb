# == Schema Information
#
# Table name: related_products
#
#  product_id :integer
#  related_id :integer
#

require 'rails_helper'

describe RelatedProduct do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:product) }

    # Validations
    it { expect(subject).to validate_uniqueness_of(:related_id).scoped_to(:product_id) }

end
