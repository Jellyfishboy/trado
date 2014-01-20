require 'spec_helper'

describe CartItem do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }
    it { expect(subject).to belong_to(:cart) }

end