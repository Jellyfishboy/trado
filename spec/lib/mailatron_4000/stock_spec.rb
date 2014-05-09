require 'spec_helper'

describe Mailatron4000::Stock do

    store_setting

    describe "Automated stock warning level" do

        before(:all) do
            create(:stock_warning_product_1)
            create(:stock_warning_product_2)
            create(:stock_warning_product_3)
        end

        context "if there is low stock" do

            it "should email administrator a list of products" do
                expect {
                    Mailatron4000::Stock.warning
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end
    end 

    describe "Notifying of new stock" do

        before(:all) do
            create(:notified_product)
        end
        context "if there are any notifications" do

            it "should email a notification to each user" do
                expect {
                    Mailatron4000::Stock.notify
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end
    end

end