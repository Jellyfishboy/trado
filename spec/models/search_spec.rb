require 'rails_helper'

describe Search do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:product) }

end