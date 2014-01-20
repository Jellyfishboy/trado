require 'spec_helper'

describe Cart do

    # ActiveRecord relations
    it { expect(subject).to have_many(:cart_items).dependent(:delete_all) }
    it { expect(subject).to have_many(:skus).through(:cart_items) }

end