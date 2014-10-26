require 'rails_helper'

describe Store::PayProvider do

    store_setting

    describe "When calculating the correct pay provider" do

        context "if the pay provider is PayPal" do

            it "should return the Payatron4000:Paypal class object" do
                expect(Store::PayProvider.new(provider: 'express-checkout').provider).to eq Payatron4000::Paypal
            end
        end
    end
end