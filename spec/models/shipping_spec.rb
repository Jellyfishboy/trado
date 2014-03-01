require 'spec_helper'

describe Shipping do

    # ActiveRecord relations
    it { expect(subject).to have_many(:tiereds).dependent(:delete_all) }
    it { expect(subject).to have_many(:tiers).through(:tiereds) }
    it { expect(subject).to have_many(:destinations).dependent(:delete_all) }
    it { expect(subject).to have_many(:zones).through(:destinations) }
    it { expect(subject).to have_many(:countries).through(:zones) }
    it { expect(subject).to have_many(:orders).dependent(:restrict) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:description) }

    it { expect(subject).to validate_uniqueness_of(:name) }

    it { expect(subject).to ensure_length_of(:name).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:description).is_at_most(180) }

    describe "When a used shipping is updated or deleted" do

        it "should set the record as inactive" do
            shipping = create(:shipping, active: true)
            shipping.inactivate!
            expect(shipping.active).to eq false
        end
    end

    describe "When the new shipping fails to update" do

        it "should set the record as active" do
            shipping = create(:shipping)
            shipping.activate!
            expect(shipping.active).to eq true
        end
    end

    it "should return an array of 'active' shippings" do
        shipping_1 = create(:shipping, active: true)
        shipping_2 = create(:shipping)
        shipping_3 = create(:shipping, active: true)
        expect(Shipping.active).to match_array([shipping_1, shipping_3])
    end

end