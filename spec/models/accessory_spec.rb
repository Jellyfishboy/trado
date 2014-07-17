require 'rails_helper'

describe Accessory do

    # ActiveRecord relations
    it { expect(subject).to have_many(:cart_item_accessories) }
    it { expect(subject).to have_many(:cart_items).through(:cart_item_accessories) }
    it { expect(subject).to have_many(:carts).through(:cart_items) }
    it { expect(subject).to have_many(:order_item_accessories).dependent(:restrict) }
    it { expect(subject).to have_many(:order_items).through(:order_item_accessories).dependent(:restrict) }
    it { expect(subject).to have_many(:orders).through(:order_items) }
    it { expect(subject).to have_many(:accessorisations).dependent(:delete_all) }
    it { expect(subject).to have_many(:products).through(:accessorisations) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:part_number) }

    it { expect(subject).to validate_numericality_of(:part_number).is_greater_than_or_equal_to(1).only_integer } 


    it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:active) }
    it { expect(subject).to validate_uniqueness_of(:part_number).scoped_to(:active) }

    describe "Listing all products" do
        let!(:accessory_1) { create(:accessory) }
        let!(:accessory_2) { create(:accessory, active: false) }
        let!(:accessory_3) { create(:accessory) }

        it "should return an array of 'active' accessorys" do
            expect(Accessory.active).to match_array([accessory_1, accessory_3])
        end
    end

    describe "After updating an accessory" do
        let!(:accessory) { create(:accessory, weight: '2.3') }
        let!(:sku) { create(:sku, weight: '14.9') }
        let!(:cart_item) { create(:cart_item, weight: '44.5', quantity: 5, sku: sku) }
        let!(:cart_item_accessory) { create(:cart_item_accessory, accessory: accessory, quantity: 5, cart_item: cart_item) }

        it "should update any associated cart_item_accessories with the new weight" do
            expect(cart_item.weight).to eq BigDecimal.new("44.5")
            accessory.update(:weight => '3.4')
            cart_item.reload
            expect(cart_item.weight).to eq BigDecimal.new("91.5")
        end
    end

end