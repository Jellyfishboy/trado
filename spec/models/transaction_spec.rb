require 'spec_helper'

describe Transaction do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:order) }

end