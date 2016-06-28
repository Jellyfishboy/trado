# == Schema Information
#
# Table name: sku_variants
#
#  id              :integer          not null, primary key
#  sku_id          :integer
#  variant_type_id :integer
#  name            :string
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe SkuVariant do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }
    it { expect(subject).to belong_to(:variant_type).class_name('VariantType') }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }

    describe "When submitting a new sku variant" do
        let(:sku_variant) { create(:sku_variant, name: ' red ') }

        it "should strip white space from the name attribute" do
            expect(sku_variant.name).to eq 'red'
        end
    end
end
