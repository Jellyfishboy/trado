require 'spec_helper'

describe Accessorisation do
  
    # ActiveRecord relations
    it { expect(subject).to belong_to(:accessory) }
    it { expect(subject).to belong_to(:product) }

    # hai
end
