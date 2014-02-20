require 'spec_helper'

describe Zonification do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:zone) }
    it { expect(subject).to belong_to(:country) }

end
