require 'spec_helper'

describe Product do

    # ActiveRecord relations
    it { expect(subject).to have_many(:skus).dependent(:delete_all) }
    it { expect(subject).to have_many(:orders).through(:skus) }
    it { expect(subject).to have_many(:carts).through(:skus) }
    it { expect(subject).to have_many(:taggings).dependent(:delete_all) }
    it { expect(subject).to have_many(:tags).through(:taggings) }
    it { expect(subject).to belong_to(:category) }

    # Validation
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:meta_description) }
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:part_number) }
    it { expect(subject).to validate_presence_of(:sku) }
    it { expect(subject).to validate_presence_of(:weighting) }

    it { expect(subject).to validate_uniqueness_of(:name) }
    it { expect(subject).to validate_uniqueness_of(:sku) }
    it { expect(subject).to validate_uniqueness_of(:part_number) }

    it { expect(subject).to validate_numericality_of(:part_number).only_integer } 
    it { expect(subject).to validate_numericality_of(:weighting).only_integer } 
    it { expect(subject).to validate_numericality_of(:part_number).is_greater_than_or_equal_to(1) } 
    it { expect(subject).to validate_numericality_of(:weighting).is_greater_than_or_equal_to(1) } 

    it { expect(subject).to ensure_length_of(:name).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:meta_description).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:description).is_at_least(20) }
end
