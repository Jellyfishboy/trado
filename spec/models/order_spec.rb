require 'rails_helper'

describe Order do

    store_setting

    # ActiveRecord relations
    it { expect(subject).to have_many(:order_items).dependent(:delete_all) }
    it { expect(subject).to have_many(:transactions).dependent(:delete_all) }
    it { expect(subject).to belong_to(:delivery).class_name('DeliveryServicePrice') }
    it { expect(subject).to belong_to(:cart) }
    it { expect(subject).to have_one(:delivery_address).class_name('Address').conditions(addressable_type: 'OrderShipAddress').dependent(:destroy) }
    it { expect(subject).to have_one(:billing_address).class_name('Address').conditions(addressable_type: 'OrderBillAddress').dependent(:destroy) }

    # Validations
    context "if the order has a an associated completed transaction record" do
        before { subject.stub(:completed?) { true } }
        it { expect(subject).to validate_presence_of(:actual_shipping_cost) }
    end

    context "if the status of the order is 'active' or 'confirm'" do
        before { subject.stub(:active_or_confirm?) { true } }
        it { expect(subject).to ensure_inclusion_of(:terms).in_array([true]).with_message('You must tick the box in order to complete your order.') }
    end

    context "if current order status is at shipping" do
        before { subject.stub(:active_or_shipping?) { true } }
        it { expect(subject).to validate_presence_of(:email).with_message('is required') }
        it { expect(subject).to validate_presence_of(:delivery_id).with_message('service must be selected.') }
        it { expect(subject).to allow_value("test@test.com").for(:email) }
        it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }
    end

    # Nested attributes
    it { expect(subject).to accept_nested_attributes_for(:delivery_address) }

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

    describe "Multi form methods" do
        let(:order_1) { create(:order, status: 'active') }
        let(:order_2) { create(:order, status: 'billing') }
        let(:order_3) { create(:order, status: 'shipping') }
        let(:order_4) { create(:order, status: 'payment') }
        let(:order_5) { create(:order, status: 'confirm') }
        let(:order_6) { create(:order, status: 'review')}

        it "should return true for an active order" do
            expect(order_1.active?).to eq true
        end

        it "should return true for a review or shipping or active order" do
            expect(order_6.active_or_review_or_shipping?).to eq true
            expect(order_3.active_or_review_or_shipping?).to eq true
            expect(order_1.active_or_review_or_shipping?).to eq true
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

        it "should create a new billing_address and delivery_address record" do
            expect{
                order
            }.to change(Address, :count).by(2)
        end

        it "should have the correct type for the billing_address record" do
            expect(order.billing_address.addressable_type).to eq 'OrderBillAddress'
        end

        it "should have the correct type for the delivery_address record" do
            expect(order.delivery_address.addressable_type).to eq 'OrderShipAddress'
        end
    end
end
