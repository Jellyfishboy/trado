require 'spec_helper'

describe Destination do

    #ActiveRecord relations
    it { expect(subject).to belong_to(:shipping) }
    it { expect(subject).to belong_to(:country) }

end