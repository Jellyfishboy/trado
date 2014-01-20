require 'spec_helper'

describe Shipping do

    # ActiveRecord relations
    it { expect(subject).to have_many(:tiereds).dependent(:delete_all) }
    it { expect(subject).to have_many(:tiers).through(:tiereds) }
    it { expect(subject).to have_many(:destinations).dependent(:delete_all) }
    it { expect(subject).to have_many(:countries).through(:destinations) }
    it { expect(subject).to have_many(:orders).dependent(:restrict) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:price) }
    it { expect(subject).to validate_presence_of(:description) }

    it { expect(subject).to validate_uniqueness_of(:name) }

    it { expect(subject).to ensure_length_of(:name).is_at_least(10) }
    it { expect(subject).to ensure_length_of(:description).is_at_most(100) }

    context "When a used shipping is updated or deleted" do

        it "should set the record as inactive" do
            shipping = create(:shipping)
            shipping.inactivate!
            expect(shipping.active).to eq false
        end
    end

    it "should return an array of 'active' shippings" do
        shipping_1 = create(:shipping)
        shipping_2 = create(:shipping, active: false)
        shipping_3 = create(:shipping)
        expect(Shipping.active).to match_array([shipping_1, shipping_3])
    end

end