require 'spec_helper'

describe Order do

    # ActiveRecord relations
    it { expect(subject).to have_many(:order_items).dependent(:delete_all) }
    it { expect(subject).to have_one(:transaction).dependent(:destroy) }
    it { expect(subject).to belong_to(:shipping) }
    it { expect(subject).to belong_to(:ship_address).class_name('Address') }
    it { expect(subject).to belong_to(:bill_address).class_name('Address') }

    context "If current order status is at shipping" do
        before { subject.stub(:active_or_shipping?) { true } }
        it { expect(subject).to validate_presence_of(:email).with_message('is required') }
        it { expect(subject).to validate_presence_of(:shipping_id).with_message('Shipping option is required') }
        it { expect(subject).to allow_value("test@test.com").for(:email) }
        it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }
    end

    describe "Managing an order shipping" do
        let(:order) { create(:order, shipping_date: nil) }
        let(:order_2) { create(:order, shipping_date: Date.today) }
        # let(:order_3) { create(:order) }

        context "If order date is today" do

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

        context "If order had a shipping date and was changed again" do
            # before(:each) do
            #     binding.pry
            #     order_3.update_column(:shipping_date, Date.new(2014, 3, 29))
            # end
            # it "should send a delayed_shipping email" do
            #     expect {
            #         binding.pry
            #         order_3.delayed_shipping
            #     }.to change {
            #         ActionMailer::Base.deliveries.count }.by(1)
            # end
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
