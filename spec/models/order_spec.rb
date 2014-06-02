require 'spec_helper'

describe Order do

    store_setting

    # ActiveRecord relations
    it { expect(subject).to have_many(:order_items).dependent(:delete_all) }
    it { expect(subject).to have_many(:transactions).dependent(:delete_all) }
    it { expect(subject).to belong_to(:shipping) }
    it { expect(subject).to belong_to(:ship_address).class_name('Address').dependent(:destroy) }
    it { expect(subject).to belong_to(:bill_address).class_name('Address').dependent(:destroy) }

    before { subject.stub(:active_or_payment?) { true } }
    it { expect(subject).to ensure_inclusion_of(:terms).in_array(%w(true)) }

    context "If current order status is at shipping" do
        
        before { subject.stub(:active_or_shipping?) { true } }
        it { expect(subject).to validate_presence_of(:email).with_message('is required') }
        it { expect(subject).to validate_presence_of(:shipping_id).with_message('Shipping option is required') }
        it { expect(subject).to allow_value("test@test.com").for(:email) }
        it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }
    end

    describe "Adding cart_items to an order" do
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

    describe "Calculating an order" do

        it "should update the order's net amount attribute"
        it "should update the order's tax amount attribute"
        it "should update the order's gross amount attribute"
    end

    describe "Managing an order shipping" do
        let(:order) { create(:order, shipping_date: nil) }
        let(:order_2) { create(:order, shipping_date: Time.now) }
        let!(:order_3) { create(:order) }

        context "if order date is today" do

            it "should update the order as dispatched" do
                expect {
                    order_2.ship_order_today
                }.to change {
                    order_2.shipping_status }.to("Dispatched")
            end

            it "should send an order_shipped email" do
                expect {
                    order_2.ship_order_today
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end

        context "if order had a shipping date and was changed again" do
            before(:each) do
                order_3.stub(:shipping_date_changed?) { true }
                order_3.stub(:shipping_date_was) { true }
            end
            it "should send a delayed_shipping email" do
                expect {
                    order_3.delayed_shipping
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end

        it "should return false if the shipping_date is nil" do
            expect(order.shipping_date_nil?).to be_false
        end

    end

    describe "Multi form methods" do
        let(:order_1) { create(:order, status: 'active') }
        let(:order_2) { create(:order, status: 'billing') }
        let(:order_3) { create(:order, status: 'shipping') }
        let(:order_4) { create(:order, status: 'payment') }

        it "should return true for an active order" do
            expect(order_1.active?).to be_true
        end

        it "should return true for a billing or active order" do
            expect(order_1.active_or_billing?).to be_true
            expect(order_2.active_or_billing?).to be_true
        end
        it "should return true for a shipping or active order" do
            expect(order_1.active_or_shipping?).to be_true
            expect(order_3.active_or_shipping?).to be_true
        end
        it "should return true for a payment or active order" do
            expect(order_1.active_or_payment?).to be_true
            expect(order_4.active_or_payment?).to be_true
        end
    end
end
