require 'spec_helper'

describe Tier do

    # Validations
    it "is valid with length_start, length_end, weight_start, weight_end, thickness_start and thickness_end" do
        expect(build(:tier)).to be_valid
    end
    it "is invalid without a length_start" do
        tier = build(:tier, length_start: nil)
        expect(tier).to have(2).errors_on(:length_start)
    end
    it "is invalid without a length_end" do
        tier = build(:tier, length_end: nil)
        expect(tier).to have(2).errors_on(:length_end)
    end
    it "is invalid without a weight_start" do
        tier = build(:tier, weight_start: nil)
        expect(tier).to have(2).errors_on(:weight_start)
    end
    it "is invalid without a weight_end" do
        tier = build(:tier, weight_end: nil)
        expect(tier).to have(2).errors_on(:weight_end)
    end
    it "is invalid without a thickness_start" do
        tier = build(:tier, thickness_start: nil)
        expect(tier).to have(2).errors_on(:thickness_start)
    end
    it "is invalid without a thickness_end" do
        tier = build(:tier, thickness_end: nil)
        expect(tier).to have(2).errors_on(:thickness_end)
    end
    it "is valid when length_start, length_end, weight_start, weight_end, thickness_start and thickness_end is equal to or more than zero" do
        expect(build(:tier)).to be_valid
    end
    it "is invalid with a length_start less than zero" do
        tier = build(:tier, length_start: -0.1)
        expect(tier).to have(1).errors_on(:length_start)
    end
    it "is invalid with a length_end less than zero" do
        tier = build(:tier, length_end: -0.2)
        expect(tier).to have(1).errors_on(:length_end)
    end
    it "is invalid with a weight_start less than zero" do
        tier = build(:tier, weight_start: -0.3)
        expect(tier).to have(1).errors_on(:weight_start)
    end
    it "is invalid with a weight_end less than zero" do
        tier = build(:tier, weight_end: -1)
        expect(tier).to have(1).errors_on(:weight_end)
    end
    it "is invalid with a thickness_start less than zero" do
        tier = build(:tier, thickness_start: -3)
        expect(tier).to have(1).errors_on(:thickness_start)
    end
    it "is invalid with a thickness_end less than zero" do
        tier = build(:tier, thickness_end: -10)
        expect(tier).to have(1).errors_on(:thickness_end)
    end

end