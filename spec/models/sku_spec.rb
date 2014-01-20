require 'spec_helper'

describe Sku do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:product) }
    it { expect(subject).to belong_to(:accessory) }
    it { expect(subject).to belong_to(:attribute_type) }
    it { expect(subject).to have_many(:cart_items).dependent(:restrict) }
    it { expect(subject).to have_many(:carts).through(:cart_items).dependent(:restrict) }
    it { expect(subject).to have_many(:order_items).dependent(:restrict) }
    it { expect(subject).to have_many(:orders).through(:order_items).dependent(:restrict) }

    # Validation
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:cost_value) }
    it { expect(subject).to validate_presence_of(:stock) }
    it { expect(subject).to validate_presence_of(:length) }
    it { expect(subject).to validate_presence_of(:weight) }
    it { expect(subject).to validate_presence_of(:thickness) }
    it { expect(subject).to validate_presence_of(:stock_warning_level) }
    it { expect(subject).to validate_presence_of(:attribute_value) }
    it { expect(subject).to validate_presence_of(:attribute_type_id) }

    it { expect(subject).to validate_numericality_of(:length).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:weight).is_greater_than_or_equal_to(0) }
    it { expect(subject).to validate_numericality_of(:thickness).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:stock).is_greater_than_or_equal_to(1) } 
    it { expect(subject).to validate_numericality_of(:stock_warning_level).is_greater_than_or_equal_to(1) } 
    it { expect(subject).to validate_numericality_of(:stock).only_integer } 
    it { expect(subject).to validate_numericality_of(:stock_warning_level).only_integer } 

    it { expect(subject).to validate_uniqueness_of(:sku) } 
    it { expect(subject).to validate_uniqueness_of(:attribute_value).scoped_to(:product_id) }
    
end