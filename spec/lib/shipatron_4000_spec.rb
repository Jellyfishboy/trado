require 'rails_helper'

describe Shipatron4000 do

    # weight 22.67
    # length 67.2
    # thickness 12.34
    describe "Calculating the relevant tiers for an order" do
        let(:cart) { create(:tier_calculated_cart) }
        let(:order) { create(:order, cart_id: cart.id) }
        let!(:tier_1) { create(:tier, weight_start: '0', weight_end: '26.75', length_start: '0', length_end: '103.23', thickness_start: '0', thickness_end: '22.71') }
        let!(:tier_2) { create(:tier, weight_start: '0', weight_end: '18.75', length_start: '0', length_end: '119.23', thickness_start: '0', thickness_end: '49.90') }
        let!(:tier_3) { create(:tier, weight_start: '22.67', weight_end: '46.75', length_start: '66.82', length_end: '201.45', thickness_start: '12.33', thickness_end: '52.62') }

        it "should return an array of tier IDs" do
            expect{
                Shipatron4000::tier(cart, order)
            }.to change{
                order.tiers
            }.from(nil).to([tier_1.id,tier_3.id])
        end
    end
end