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

    describe "Default scope" do
        let!(:variant_type_1) { create(:variant_type, name: 'Color') }
        let!(:variant_type_2) { create(:variant_type, name: 'Size') }

        it "should return an array of cart items ordered by descending created_at" do
            expect(VariantType.all).to match_array([variant_type_1, variant_type_2])
        end
    end
end
