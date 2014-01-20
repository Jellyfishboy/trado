require 'spec_helper'

describe Shipping do

    # ActiveRecord relations
    it { expect(subject).to have_many(:tiereds).dependent(:delete_all) }
    it { expect(subject).to have_many(:tiers).through(:tiereds) }
    it { expect(subject).to have_many(:destinations).dependent(:delete_all) }
    it { expect(subject).to have_many(:countries).through(:destinations) }
    it { expect(subject).to have_many(:orders).dependent(:restrict) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:description) }

    it { expect(subject).to validate_uniqueness_of(:name) }

    it { expect(subject).to ensure_length_of(:name).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:description).is_at_most(100) }

end