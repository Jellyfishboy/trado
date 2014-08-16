require 'rails_helper'

describe DeliveryServicePriceHelper do

    describe '#dimension_range' do
        let(:min) { '2.50' }
        let(:max) { '10.23' }

        it "should return a concatenation of two values, seperated by a hyphen" do
            expect(dimension_range(min, max)).to eq '2.50 - 10.23'
        end
    end
end
