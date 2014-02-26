require 'spec_helper'

describe Payatron4000::Paypal do

    it "should create an object of order details for reviewal"
    it "should create an object of order details for purchase"
    it "should create a JSON object of order items"

    describe "Verfiying a Paypal order" do

        it "should retrieve the details for the PayPal express session"
        it "should update the order with a token and payer_id"
        it "should set the session paypal_email as the current PayPal user"
    end

    describe "Successful order" do

        it "should create a successful transaction"
        it "should set the order status as active"
    end

    describe "Failed order" do

        it "should create a failed transaction"
        it "should set the order status as active"
    end

end