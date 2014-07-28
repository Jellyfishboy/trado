require 'rails_helper'

describe Mailatron4000::Stock do

    store_setting

    describe "Notifying of new stock" do

        before(:each) do
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