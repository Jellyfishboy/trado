require 'spec_helper'

describe Mailatron4000::Stock do

    describe "Automated stock warning level" do

        before(:all) do
            build(:sku, stock: 5, stock_warning_level: 10).save(validate: false)
            build(:sku, stock: 20, stock_warning_level: 5).save(validate: false)
            build(:sku, stock: 7, stock_warning_level: 15).save(validate: false)
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
            create(:sku_in_stock)
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