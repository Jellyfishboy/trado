require 'rails_helper'

describe Admin::TransactionsController do

    store_setting
    login_admin

    describe 'POST #paypal_ipn' do
        let!(:order) { create(:ipn_order) }
        before do  
            ActiveMerchant::Billing::Base.mode = :test  
            ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stub(:acknowledge).and_return(true)  
            ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stub(:completed?).and_return(true)
        end 
        let(:successful_request) {
                post :paypal_ipn , {    "mc_gross"=> "234.71",  
                                        "invoice"=> order.id,  
                                        "mc_fee"=> "7.23",   
                                        "payment_status"=>"Completed",   
                                        "payer_id"=>"12345678"
                                    }
        }
        let(:failed_request) {
                post :paypal_ipn , {    "mc_gross"=> "111.71",  
                                        "invoice"=> order.id,  
                                        "mc_fee"=> "7.23",   
                                        "payment_status"=>"Completed",   
                                        "payer_id"=>"12345678"
                                    }
        }    
        context "with correct parameters" do
            
            before(:each) do
                successful_request
                order.reload
            end

            it "should set the transaction fee provided by PayPal" do
                expect(order.transactions.last.fee).to eq BigDecimal.new("7.23")
            end

            it "should set the payment status provided by PayPal" do
                expect(order.transactions.last.payment_status).to eq 'Completed'
            end

            it "should send an order received email" do
                expect(ActionMailer::Base.deliveries.count).to eq 1
            end

            it "should render nothing" do
                expect(response.body).to be_blank
            end
        end

        context "with incorrect parameters" do
            
            before(:each) do
                failed_request
                order.reload
            end

            it "should set the transaction payment status to failed" do
                expect(order.transactions.last.payment_status).to eq 'Failed'
            end
 
            it "should send an order failed email" do
                expect(ActionMailer::Base.deliveries.count).to eq 1
            end

            it "should render nothing" do
                expect(response.body).to be_blank
            end
        end
    end
end