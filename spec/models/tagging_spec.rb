require 'rails_helper'

describe Tagging do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:tag) }
    it { expect(subject).to belong_to(:product) }
end