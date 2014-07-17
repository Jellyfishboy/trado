require 'rails_helper'

describe Role do

    # ActiveRecord relations
    it { expect(subject).to have_many(:permissions).dependent(:delete_all) }
    it { expect(subject).to have_many(:users).through(:permissions) }
end
