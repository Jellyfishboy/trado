require 'spec_helper'

describe Mailatron4000::Stock do

    describe "Automated stock warning level" do

        FactoryGirl.build(:sku, stock: 5, stock_warning_level: 10).save(validate: false)
        FactoryGirl.build(:sku, stock: 20, stock_warning_level: 5).save(validate: false)
        FactoryGirl.build(:sku, stock: 7, stock_warning_level: 15).save(validate: false)

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

        context "if there are any notifications" do

            it "should email administrator a list of products" do
                expect {
                    Mailatron4000::Stock.notify
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end
        end
    end

end