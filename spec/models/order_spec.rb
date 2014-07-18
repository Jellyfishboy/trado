require 'rails_helper'

describe Order do

    store_setting

    # ActiveRecord relations
    it { expect(subject).to have_many(:order_items).dependent(:delete_all) }
    it { expect(subject).to have_many(:transactions).dependent(:delete_all) }
    it { expect(subject).to belong_to(:shipping) }
    it { expect(subject).to belong_to(:cart) }
    it { expect(subject).to have_one(:ship_address).class_name('Address').conditions(addressable_type: 'OrderShipAddress').dependent(:destroy) }
    it { expect(subject).to have_one(:bill_address).class_name('Address').conditions(addressable_type: 'OrderBillAddress').dependent(:destroy) }

    # Validations
    context "If the order has a an associated completed transaction record" do
        before { subject.stub(:completed?) { true } }
        it { expect(subject).to validate_presence_of(:actual_shipping_cost) }
    end

    context "If the status of the order is 'active' or 'confirm'" do
        before { subject.stub(:active_or_confirm?) { true } }
        it { expect(subject).to ensure_inclusion_of(:terms).in_array([true]).with_message('You must tick the box in order to complete your order.') }
    end

    context "If current order status is at shipping" do
        before { subject.stub(:active_or_shipping?) { true } }
        it { expect(subject).to validate_presence_of(:email).with_message('is required') }
        it { expect(subject).to validate_presence_of(:shipping_id).with_message('Shipping option is required') }
        it { expect(subject).to allow_value("test@test.com").for(:email) }
        it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }
    end

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:ship_address) }

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

        it "should update the order's net amount attribute" do
            expect(order.net_amount).to eq cart.total_price + order.shipping.price
        end
        it "should update the order's tax amount attribute" do
            expect(order.tax_amount).to eq (cart.total_price + order.shipping.price) * tax
        end
        it "should update the order's gross amount attribute" do
            expect(order.gross_amount).to eq (cart.total_price + order.shipping.price) + ((cart.total_price + order.shipping.price) * tax)
        end
    end

    describe "When updating an order" do
        let(:order) { create(:order, shipping_date: nil) }
        let(:order_2) { create(:order, shipping_date: Time.now) }
        let!(:order_3) { create(:order) }

        it "should call ship_order_today method after" do
            Order._update_callbacks.select { |cb| cb.kind.eql?(:after) }.map(&:raw_filter).include?(:ship_order_today).should == true
        end

        context "if order shipping date is today" do

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

        it "should return false if the shipping_date is nil" do
            expect(order.shipping_date_nil?).to eq false
        end

        it "should return true if the shipping_date is not nil" do
            expect(order_3.shipping_date_nil?).to eq true
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

    describe "Multi form methods" do
        let(:order_1) { create(:order, status: 'active') }
        let(:order_2) { create(:order, status: 'billing') }
        let(:order_3) { create(:order, status: 'shipping') }
        let(:order_4) { create(:order, status: 'payment') }
        let(:order_5) { create(:order, status: 'confirm') }

        it "should return true for an active order" do
            expect(order_1.active?).to eq true
        end

        it "should return true for a billing or active order" do
            expect(order_1.active_or_billing?).to eq true
            expect(order_2.active_or_billing?).to eq true
        end
        it "should return true for a shipping or active order" do
            expect(order_1.active_or_shipping?).to eq true
            expect(order_3.active_or_shipping?).to eq true
        end
        it "should return true for a payment or active order" do
            expect(order_1.active_or_payment?).to eq true
            expect(order_4.active_or_payment?).to eq true
        end
        it "should return true for a payment or active order" do
            expect(order_1.active_or_confirm?).to eq true
            expect(order_5.active_or_confirm?).to eq true
        end
    end

    describe "During a daily scheduled task" do

        context "if the orders are more than 12 hours old but their status is set to active" do
            let!(:order_1) { create(:order, updated_at: 11.hours.ago) }
            let!(:order_2) { create(:order, updated_at: 13.hours.ago) }
            let!(:order_3) { create(:order, updated_at: 28.hours.ago) }

            it "should select the correct orders" do
                expect(Order.clear_orders).to match_array([])
            end

            it "should not remove any orders" do
                expect{
                    Order.clear_orders
                }.to change(Order, :count).by(0)
            end
        end

        context "if the orders are more than 12 years old and their status is not set to active" do
            let!(:order_1) { create(:order, updated_at: 11.hours.ago, status: 'shipping') }
            let!(:order_2) { create(:order, updated_at: 13.hours.ago, status: 'review') }
            let!(:order_3) { create(:order, updated_at: 28.hours.ago, status: 'billing') }

            it "should select the correct orders" do
                expect(Order.clear_orders).to match_array([order_2, order_3])
            end

            it "should remove the orders" do
                expect{
                    Order.clear_orders
                }.to change(Order, :count).by(-2)
            end
        end
    end

    describe "After creating a new order" do
        let(:order) { create(:order) }

        it "should call create_addresses method after" do
            Order._create_callbacks.select { |cb| cb.kind.eql?(:after) }.map(&:raw_filter).include?(:create_addresses).should == true
        end

        it "should create a new bill_address and ship_address record" do
            expect{
                order
            }.to change(Address, :count).by(2)
        end

        it "should have the correct type for the bill_address record" do
            expect(order.bill_address.addressable_type).to eq 'OrderBillAddress'
        end

        it "should have the correct type for the ship_address record" do
            expect(order.ship_address.addressable_type).to eq 'OrderShipAddress'
        end
    end
end
