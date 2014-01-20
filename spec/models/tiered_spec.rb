require 'spec_helper'

describe Tiered do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:tier) }
    it { expect(subject).to belong_to(:shipping) }

end