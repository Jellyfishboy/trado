require 'spec_helper'

describe Accessory do

    # ActiveRecord relations
    it { expect(subject).to have_many(:cart_item_accessories) }
    it { expect(subject).to have_many(:cart_items).through(:cart_item_accessories) }
    it { expect(subject).to have_many(:carts).through(:cart_items) }
    it { expect(subject).to have_many(:order_item_accessories).dependent(:restrict) }
    it { expect(subject).to have_many(:order_items).through(:order_item_accessories).dependent(:restrict) }
    it { expect(subject).to have_many(:orders).through(:order_items) }
    it { expect(subject).to have_many(:accessorisations).dependent(:delete_all) }
    it { expect(subject).to have_many(:products).through(:accessorisations) }
    it { expect(subject).to have_one(:attachment).dependent(:destroy) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:part_number) }

    it { expect(subject).to validate_numericality_of(:part_number).only_integer } 
    it { expect(subject).to validate_numericality_of(:part_number).is_greater_than_or_equal_to(1) } 


    it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:active) }
    it { expect(subject).to validate_uniqueness_of(:part_number).scoped_to(:active) }

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:attachment) }

end