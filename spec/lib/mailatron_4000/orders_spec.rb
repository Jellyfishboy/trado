require 'rails_helper'

describe Mailatron4000::Orders do

    store_setting

    describe "Dispatching orders" do
        let!(:order){ create(:addresses_pending_order, shipping_date: Time.now) }
        
        context "if order delivery date is today" do

            it "should update the order as dispatched" do
                expect {
                    Mailatron4000::Orders.dispatch_all
                    order.reload
                }.to change {
                    order.shipping_status }.to('dispatched')
            end

            it "should deliver an order_shipped email" do
                expect {
                    Mailatron4000::Orders.dispatch_all
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end
    end

    describe "When completing an order" do

        context "if the payment status is pending" do
            let!(:pending) { create(:addresses_pending_order) }

            it "should send a pending email confirmation", broken: true do
                expect{
                    Mailatron4000::Orders.confirmation_email(pending)
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end

        context "if the payment status is completed" do
            let!(:completed) { create(:addresses_complete_order) }

            it "should send a completed email confirmation", broken: true do
                expect{
                    Mailatron4000::Orders.confirmation_email(completed)
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end

        context "if the payment status is failed" do
            let!(:failed) { create(:addresses_failed_order) }
            
            it "should send a completed email confirmation", broken: true do
                expect{
                    Mailatron4000::Orders.confirmation_email(failed)
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end
    end
end
