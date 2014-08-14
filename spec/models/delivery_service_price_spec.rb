require 'rails_helper'

describe DeliveryServicePrice do

    # ActiveRecord relations
    it { expect(subject).to have_many(:orders).dependent(:restrict_with_exception) }
    it { expect(subject).to belong_to(:delivery_service) }

    # Validations
    it { expect(subject).to validate_presence_of(:code) }
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:min_weight) }
    it { expect(subject).to validate_presence_of(:max_weight) }
    it { expect(subject).to validate_presence_of(:min_length) }
    it { expect(subject).to validate_presence_of(:max_length) }
    it { expect(subject).to validate_presence_of(:min_thickness) }
    it { expect(subject).to validate_presence_of(:max_thickness) }

    it { expect(subject).to validate_uniqueness_of(:code).scoped_to([:active, :delivery_service_id]) }

    it { expect(subject).to ensure_length_of(:description).is_at_most(180) }

    describe "Default scope" do
        let!(:delivery_service_price_1) { create(:delivery_service_price, price: '1.22') }
        let!(:delivery_service_price_2) { create(:delivery_service_price, price: '5.67') }
        let!(:delivery_service_price_3) { create(:delivery_service_price, price: '110.23') }

        it "should return an array of products ordered by descending weighting" do
            expect(DeliveryServicePrice.last(3)).to match_array([delivery_service_price_1, delivery_service_price_2, delivery_service_price_3])
        end
    end

    describe "Listing all shippings" do
        let!(:delivery_service_price_1) { create(:delivery_service_price, active: true) }
        let!(:delivery_service_price_2) { create(:delivery_service_price) }
        let!(:delivery_service_price_3) { create(:delivery_service_price, active: true) }

        it "should return an array of 'active' shippings" do
            expect(DeliveryServicePrice.active).to match_array([delivery_service_price_1, delivery_service_price_3])
        end
    end

end