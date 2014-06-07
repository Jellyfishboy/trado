require 'spec_helper'

describe Shipatron4000 do

    # weight 22.67
    # length 101.87
    # thickness 22.15
    describe "Calculating the relevant tiers for an order" do
        let(:cart) { create(:tier_calculated_cart) }
        let!(:tier_1) { create(:tier, weight_start: BigDecimal.new("0"), weight_end: BigDecimal.new("26.75"), length_start: BigDecimal.new("0"), length_end: BigDecimal.new("103.23"), thickness_start: BigDecimal.new("0"), thickness_end: BigDecimal.new("22.71")) }
        let!(:tier_2) { create(:tier, weight_start: BigDecimal.new("0"), weight_end: BigDecimal.new("18.75"), length_start: BigDecimal.new("0"), length_end: BigDecimal.new("119.23"), thickness_start: BigDecimal.new("0"), thickness_end: BigDecimal.new("49.90")) }
        let!(:tier_3) { create(:tier, weight_start: BigDecimal.new("19.90"), weight_end: BigDecimal.new("46.75"), length_start: BigDecimal.new("75.82"), length_end: BigDecimal.new("201.45"), thickness_start: BigDecimal.new("22.13"), thickness_end: BigDecimal.new("52.62")) }

        it "should return an array of tier IDs" do
            expect(Shipatron4000::tier(cart)).to match_array([1,2])
        end
    end
end