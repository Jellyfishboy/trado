require 'spec_helper'

describe Shipatron4000 do

    # weight 22.67
    # length 67.2
    # thickness 12.34
    describe "Calculating the relevant tiers for an order" do
        let(:cart) { create(:tier_calculated_cart) }
        Tier.destroy_all
        let!(:tier_1) { create(:tier, weight_start: BigDecimal.new("0"), weight_end: BigDecimal.new("26.75"), length_start: BigDecimal.new("0"), length_end: BigDecimal.new("103.23"), thickness_start: BigDecimal.new("0"), thickness_end: BigDecimal.new("22.71")) }
        let!(:tier_2) { create(:tier, weight_start: BigDecimal.new("0"), weight_end: BigDecimal.new("18.75"), length_start: BigDecimal.new("0"), length_end: BigDecimal.new("119.23"), thickness_start: BigDecimal.new("0"), thickness_end: BigDecimal.new("49.90")) }
        let!(:tier_3) { create(:tier, weight_start: BigDecimal.new("22.67"), weight_end: BigDecimal.new("46.75"), length_start: BigDecimal.new("66.82"), length_end: BigDecimal.new("201.45"), thickness_start: BigDecimal.new("12.33"), thickness_end: BigDecimal.new("52.62")) }

        it "should return an array of tier IDs" do
            expect(Shipatron4000::tier(cart)).to match_array([1,3])
        end
    end
end