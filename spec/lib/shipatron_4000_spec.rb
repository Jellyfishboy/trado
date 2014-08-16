require 'rails_helper'

describe Shipatron4000 do

    # weight 22.67
    # length 67.2
    # thickness 12.34
    describe "Calculating the relevant delivery service prices for an order" do
        let(:cart) { create(:tier_calculated_cart) }
        let(:order) { create(:order, cart_id: cart.id) }
        let!(:delivery_service) { create(:delivery_service, active: true)}
        let!(:delivery_service_price_1) { create(:delivery_service_price, active: true, min_weight: '0', max_weight: '26.75', min_length: '0', max_length: '103.23', min_thickness: '0', max_thickness: '22.71') }
        let!(:delivery_service_price_2) { create(:delivery_service_price, active: true, min_weight: '0', max_weight: '18.75', min_length: '0', max_length: '119.23', min_thickness: '0', max_thickness: '49.90') }
        let!(:delivery_service_price_3) { create(:delivery_service_price, active: true, min_weight: '22.67', max_weight: '46.75', min_length: '66.82', max_length: '201.45', min_thickness: '12.33', max_thickness: '52.62') }

        it "should update the order with the available delivery service prices" do
            expect{
                Shipatron4000::delivery_prices(cart, order)
            }.to change{
                order.delivery_service_prices
            }.from(nil).to([delivery_service_price_1.id,delivery_service_price_3.id])
        end
    end
end