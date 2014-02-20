require 'spec_helper'

describe Tier do

    # ActiveRecord relations
    it { expect(subject).to have_many(:tiereds).dependent(:delete_all) }
    it { expect(subject).to have_many(:shippings).through(:tiereds) }

    # Validations
    it { expect(subject).to validate_presence_of(:length_start) }
    it { expect(subject).to validate_presence_of(:length_end) }
    it { expect(subject).to validate_presence_of(:weight_start) }
    it { expect(subject).to validate_presence_of(:weight_end) }
    it { expect(subject).to validate_presence_of(:thickness_start) }
    it { expect(subject).to validate_presence_of(:thickness_end) }

    it { expect(subject).to validate_numericality_of(:length_start).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:length_end).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:weight_start).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:weight_end).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:thickness_start).is_greater_than_or_equal_to(0) } 
    it { expect(subject).to validate_numericality_of(:thickness_end).is_greater_than_or_equal_to(0) } 

end