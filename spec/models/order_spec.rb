require 'rails_helper'

describe Order do

    store_setting

    # ActiveRecord relations
    it { expect(subject).to have_many(:order_items).dependent(:delete_all) }
    it { expect(subject).to have_many(:transactions).dependent(:delete_all) }
    it { expect(subject).to have_many(:products).through(:order_items) }
    it { expect(subject).to have_many(:skus).through(:order_items) }
    it { expect(subject).to belong_to(:delivery).class_name('DeliveryServicePrice') }
    it { expect(subject).to belong_to(:cart) }
    it { expect(subject).to have_one(:delivery_address).class_name('Address').conditions(addressable_type: 'OrderShipAddress').dependent(:destroy) }
    it { expect(subject).to have_one(:billing_address).class_name('Address').conditions(addressable_type: 'OrderBillAddress').dependent(:destroy) }

    # Validations
    before { subject.stub(:completed?) { true } }
    it { expect(subject).to validate_presence_of(:actual_shipping_cost) }
    it { expect(subject).to validate_inclusion_of(:terms).in_array([true]).with_message('You must tick the box in order to place your order.') }
    it { expect(subject).to validate_presence_of(:delivery_id).with_message('Delivery option must be selected.') }
    it { expect(subject).to validate_presence_of(:email).with_message('is required') }
    it { expect(subject).to allow_value("test@test.com").for(:email) }
    it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:delivery_address) }
    it { expect(subject).to accept_nested_attributes_for(:billing_address) }

    describe "Default scope" do
        let!(:order_1) { create(:order, created_at: 1.hour.ago) }
        let!(:order_2) { create(:order, created_at: 6.hours.ago) }
        let!(:order_3) { create(:order, created_at: Time.now) }

        it "should return an array of orders ordered by descending created at value" do
            expect(Order.last(3)).to match_array([order_3, order_1, order_2])
        end
    end

    describe "Retrieving records which have associated transaction records" do
        let!(:order_1) { create(:order) }
        let!(:order_2) { create(:pending_order) }
        let!(:order_3) { create(:complete_order) }
        let!(:order_4) { create(:failed_order) }

        it "should return order records which have at least one associated transaction record" do
            expect(Order.active).to match_array [order_2, order_3, order_4]
        end
    end

    describe "When adding cart_items to an order" do
        let(:cart) { create(:full_cart) }
        let(:order) { create(:order) }

        it "should build an order_item from the cart_item data" do
            expect { 
                order.transfer(cart)
            }.to change(OrderItem, :count).by(4)
        end

        context "if cart_item has an accessory" do
            
            it "should create an order_item_accessory for the associated order_item" do
                expect {
                    order.transfer(cart)
                }.to change(OrderItemAccessory, :count).by(3)
            end
        end
    end

    describe "When calculating an order" do
        let!(:cart) { create(:full_cart) }
        let!(:tax) { BigDecimal.new("0.2") }
        let(:order) { create(:order) }
        before(:each) do
            order.calculate(cart, tax)
        end

        it "should update the order's cart_id attribute" do
            expect(order.cart_id).to eq cart.id
        end
        it "should update the order's net amount attribute" do
            expect(order.net_amount).to eq cart.total_price
        end
        it "should update the order's tax amount attribute" do
            expect(order.tax_amount).to eq (cart.total_price + order.delivery.price) * tax
        end
        it "should update the order's gross amount attribute" do
            expect(order.gross_amount).to eq (cart.total_price + order.delivery.price) + ((cart.total_price + order.delivery.price) * tax)
        end
    end

    describe "When calculating whether an order is completed" do
        let(:complete) { create(:complete_order) }
        let(:pending) { create(:pending_order) }
        it "should return true if the any associated transactions have they payment_status attribute set to 'Completed" do
            expect(complete.completed?).to eq true
        end

        it "should return false if there are no associated transaction records which have a their payment_status attribute set to 'Completed'" do
            expect(pending.completed?).to eq false
        end
    end
end
