require 'spec_helper'

describe Tag do

    # ActiveRecord relations
    it { expect(subject).to have_many(:taggings).dependent(:delete_all) }
    it { expect(subject).to have_many(:products).through(:taggings) }

end