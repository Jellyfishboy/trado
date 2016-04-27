require 'rails_helper'

describe DeliveryService do

    # ActiveRecord relations
    it { expect(subject).to have_many(:destinations).dependent(:destroy) }
    it { expect(subject).to have_many(:countries).through(:destinations) }
    it { expect(subject).to have_many(:prices).class_name('DeliveryServicePrice').dependent(:destroy) }
    it { expect(subject).to have_many(:orders).through(:prices) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:courier_name) }
    it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:courier_name) }
    it { expect(subject).to validate_length_of(:description).is_at_most(180) }

    describe "Default scope" do
        let!(:delivery_service_1) { create(:delivery_service, courier_name: 'abc') }
        let!(:delivery_service_2) { create(:delivery_service, courier_name: 'zaa') }
        let!(:delivery_service_3) { create(:delivery_service, courier_name: 'hkj') }

        it "should return an array of products ordered by descending weighting" do
            expect(DeliveryService.last(3)).to match_array([delivery_service_1, delivery_service_3, delivery_service_2])
        end
    end

    describe "Listing all delivery services" do
        let!(:delivery_service_1) { create(:delivery_service) }
        let!(:delivery_service_2) { create(:delivery_service, active: true) }
        let!(:delivery_service_3) { create(:delivery_service, active: true) }

        it "should return an array of active delivery services" do
            expect(DeliveryService.active).to match_array([delivery_service_2, delivery_service_3])
        end
    end

    describe 'When displaying a delivery service' do
        let!(:delivery_service) { create(:delivery_service, courier_name: 'Royal Mail', name: '1st Class') }

        it "should concatenate and return the courier name and the delivery service name as a string" do
            expect(delivery_service.full_name). to eq 'Royal Mail 1st Class'
        end
    end
end