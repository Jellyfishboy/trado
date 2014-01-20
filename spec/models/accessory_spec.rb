require 'spec_helper'

describe Accessory do

    # ActiveRecord relations
    it { expect(subject).to have_one(:sku).dependent(:destroy) }
    it { expect(subject).to have_many(:orders).through(:sku) }
    it { expect(subject).to have_many(:carts).through(:sku) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:part_number) }

    it { expect(subject).to validate_numericality_of(:part_number).only_integer } 
    it { expect(subject).to validate_numericality_of(:part_number).is_greater_than_or_equal_to(1) } 


    it { expect(subject).to validate_uniqueness_of(:name) }
    it { expect(subject).to validate_uniqueness_of(:part_number) }

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:sku) }

end