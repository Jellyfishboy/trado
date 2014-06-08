require 'spec_helper'

describe Payatron4000::Generic do

    describe "When creating a successful order" do

        it "should create a new transaction record" do

        end

        context "if the payment type is 'Cheque'" do

            it "should set the transaction payment type value to 'Cheque'" do

            end
        end

        context "if the payment type is 'Bank transfer'" do

            it "should set the transaction payment type value to 'Bank transfer'" do

            end
        end


        it "should update the associated SKU stock levels" do

        end

        it "should update the order's status attribute to active" do

        end
    end

    describe "When completing an order" do

        it "should redirect to the succesful order page" do

        end
    end

end