require 'spec_helper'

describe Payatron4000::Paypal do

    it "should create an object of order details for reviewal"
    it "should create an object of order details for purchase"
    it "should create a JSON object of order items"

    describe "Verfiying a Paypal order" do

        it "should retrieve the details for the PayPal express session"
        it "should update the order with a token and payer_id"
    end

    describe "Successful order" do

        it "should create a successful transaction"
        it "should set the order status attribute as 'active'"
    end

    describe "Failed order" do

        # let(:order) { create(:order) }
        # let(:failed_response) { ActiveSupport::JSON.decode(File.open(File.join('spec', 'dummy_data', 'failed_paypal_order.json'))) }
        # let(:failed) { Payatron4000::Paypal.failed(failed_response, order) }

        it "should create a transaction record"
        it "should set the transaction record payment type attribute as failed"
        it "should set the order status attribute as 'active'"
    end

end