require 'spec_helper'

describe Store do

    describe "When a redundant record is updated or deleted" do
        let(:product) { create(:product, active: true) }

        it "should set the record as inactive" do
            Store::inactivate!(product)
            expect(product.active).to eq false
        end
    end

    describe "When the record fails to update" do
        let(:product) { create(:product) }

        it "should set the record as active" do
            Store::activate!(product)
            expect(product.active).to eq true
        end
    end
end