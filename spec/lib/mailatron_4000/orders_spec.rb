require 'spec_helper'

describe Mailatron4000::Orders do

    store_setting

    describe "Dispatching orders" do

        let!(:order){ create(:order, shipping_date: Time.now) }
        
        context "if order delivery date is today" do

            it "should update the order as dispatched" do
                expect {
                    Mailatron4000::Orders.dispatch_all
                }.to change {
                    Order.first.shipping_status }.to('Dispatched')
            end

            it "should deliver an order_shipped email" do
                expect {
                    Mailatron4000::Orders.dispatch_all
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end
    end

end
