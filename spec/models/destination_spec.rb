require 'rails_helper'

describe Destination do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:delivery_service) }
    it { expect(subject).to belong_to(:country) }

end