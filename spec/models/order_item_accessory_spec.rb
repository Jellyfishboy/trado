require 'spec_helper'

describe OrderItemAccessory do
  
    # ActiveRecord relations
    it { expect(subject).to belong_to(:order_item) }
    it { expect(subject).to belong_to(:accessory) }

end
