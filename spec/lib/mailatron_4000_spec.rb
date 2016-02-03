require 'rails_helper'

describe Mailatron4000 do

    describe "Completing a notification" do

        let(:notification) { create(:notification) }

        it "should mark a notification as sent" do
            expect { 
                Mailatron4000.notification_sent(notification)
            }.to change {
                notification.sent }.to(true)
        end
        it "should set the notifiation sent_as attribute as the current time" do
            expect { 
                Mailatron4000.notification_sent(notification)
            }.to change {
                notification.sent_at.to_s }.to(Time.now.in_time_zone.to_s)
        end
    end 

end