require 'spec_helper'

describe CartItemAccessory do
  
    # Activerecord relations
    it { expect(subject).to belong_to(:cart_item) }
    it { expect(subject).to belong_to(:accessory) }

end
