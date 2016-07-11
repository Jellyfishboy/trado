require 'rails_helper'

describe DeliveryServicePriceHelper do

    describe '#dimension_range' do
        let(:min) { '2.50' }
        let(:max) { '10.23' }

        it "should return a concatenation of two values, seperated by a hyphen" do
            expect(dimension_range(min, max)).to eq '2.50 - 10.23'
        end
    end

    describe '#cart_delivery_price' do
        let!(:delivery_service_price) { create(:delivery_service_price) }
        let!(:cart) { create(:cart, delivery_id: delivery_service_price.id) }

        context "if the parameter is nil" do

            it "should return 0" do
                expect(cart_delivery_price(nil)).to eq 0
            end
        end

        context "if the parameter is not nil" do

            it "should return it's value" do
                expect(cart_delivery_price(cart.delivery)).to eq delivery_service_price.price
            end
        end
    end
end
