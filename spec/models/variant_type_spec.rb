# == Schema Information
#
# Table name: variant_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe VariantType do

    # ActiveRecord relations
    it { expect(subject).to have_many(:sku_variants) }
    it { expect(subject).to have_many(:skus).through(:sku_variants) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }

end
