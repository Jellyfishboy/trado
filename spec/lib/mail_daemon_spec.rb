require 'spec_helper'

describe MailDaemon do

    describe "Dispatching orders" do

        let!(:order) { create(:order, shipping_date: Date.today) }
        context "if order delivery date is today" do

            it "should update the order as dispatched" do
                expect {
                    MailDaemon.dispatch_orders
                }.to change {
                    order.shipping_status }.to('Dispatched')
            end

            it "should deliver an order_shipped email" do
                expect {
                    MailDaemon.dispatch_orders
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end
    end

    describe "Automated stock warning level" do

        # FactoryGirl.create(:sku, stock: 5, stock_warning_level: 10)
        # FactoryGirl.create(:sku, stock: 20, stock_warning_level: 5)
        # FactoryGirl.create(:sku, stock: 7, stock_warning_level: 15)

        # it "should find all records which has a stock value lower than it's stock_warning_level" do
        #     expect {
        #         MailDaemon.stock_warning_level
        #     }.to change {
        #         @restock.count }.by(2)
        # end

        # context "if there is low stock" do

        #     it "email administrator a list of products" do
        #         expect {
        #             MailDaemon.stock_warning_level
        #         }.to change {
        #             ActionMailer::Base.deliveries.count }.by(1)
        #     end
        # end
    end 

    describe "Notifying of new stock" do

        it "should find all SKUs which have new stock and notifications which have yet to be sent"

        context "if there are any notifications" do

            it "should deliver an email notification to the user"
        end
    end

    describe "Completing a notification" do

        let(:notification) { create(:notification) }

        it "should mark a notification as sent" do
            expect { 
                MailDaemon.mark_notification_as_sent(notification)
            }.to change {
                notification.sent }.to(true)
        end
        it "should set the notifiation sent_as attribute as the current time" do
            expect { 
                MailDaemon.mark_notification_as_sent(notification)
            }.to change {
                notification.sent_at }.to(Time.now)
        end
    end 

end