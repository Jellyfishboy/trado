require 'spec_helper'

describe Tier do

    # Validations
    it "is valid with length_start, length_end, weight_start, weight_end, thickness_start and thickness_end"
    it "is invalid without a length_start"
    it "is invalid without a length_end"
    it "is invalid without a weight_start"
    it "is invalid without a weight_end"
    it "is invalid without a thickness_start"
    it "is invalid without a thickness_end"
    it "is valid when length_start, length_end, weight_start, weight_end, thickness_start and thickness_end is equal to or more than one"
    it "is invalid with a length_start less than one"
    it "is invalid with a length_end less than one"
    it "is invalid with a weight_start less than one"
    it "is invalid with a weight_end less than one"
    it "is invalid with a thickness_start less than one"
    it "is invalid with a thickness_end less than one"

end