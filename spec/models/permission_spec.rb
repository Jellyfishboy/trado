require 'rails_helper'

describe Permission do

    it { expect(subject).to belong_to(:user) }
    it { expect(subject).to belong_to(:role) }
end