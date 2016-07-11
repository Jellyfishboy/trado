require 'rails_helper'

describe Store::PayProvider, broken: true do

    store_setting

    describe "When calculating the correct pay provider" do

        context "if the pay provider is PayPal" do

            it "should return the TradoPaypalModule:Paypaler class object" do
                expect(Store::PayProvider.new(provider: 'paypal').provider).to eq TradoPaypalModule::Paypaler
            end
        end
    end
end