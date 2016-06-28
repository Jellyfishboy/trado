# require 'rails_helper'

# describe Admin::TransactionsController, broken: true do

#     store_setting
#     login_admin

#     describe 'POST #paypal_ipn' do
#         let!(:order) { create(:ipn_order) }
#         before do  
#             ActiveMerchant::Billing::Base.mode = :test  
#             ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stub(:acknowledge).and_return(true)  
#             ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stub(:completed?).and_return(true)
#         end 
#         let(:successful_request) {
#                 post :paypal_ipn , {    "mc_gross"=> "234.71",  
#                                         "invoice"=> order.id,  
#                                         "mc_fee"=> "7.23",   
#                                         "payment_status"=>"Completed",   
#                                         "payer_id"=>"12345678"
#                                     }
#         }
#         let(:failed_request) {
#                 post :paypal_ipn , {    "mc_gross"=> "111.71",  
#                                         "invoice"=> order.id,  
#                                         "mc_fee"=> "7.23",   
#                                         "payment_status"=>"Completed",   
#                                         "payer_id"=>"12345678"
#                                     }
#         }    
#         context "with correct parameters" do
            
#             before(:each) do
#                 successful_request
#                 order.reload
#             end

#             it "should set the transaction fee provided by PayPal" do
#                 expect(order.latest_transaction.fee).to eq BigDecimal.new("7.23")
#             end

#             it "should set the payment status provided by PayPal" do
#                 expect(order.latest_transaction.payment_status).to eq 'completed'
#             end

#             it "should send an order completed email", broken: true do
#                 message_delivery = instance_double(ActionMailer::MessageDelivery)
#                 expect(OrderMailer).to receive(:completed).with(order).and_return(message_delivery)
#                 expect(message_delivery).to receive(:deliver_later)
#             end

#             it "should render nothing" do
#                 expect(response.body).to be_blank
#             end
#         end

#         context "with incorrect parameters" do
            
#             before(:each) do
#                 failed_request
#                 order.reload
#             end

#             it "should set the transaction payment status to failed" do
#                 expect(order.latest_transaction.payment_status).to eq 'failed'
#             end
 
#             it "should send an order failed email", broken: true do
#                 expect(ActionMailer::Base.deliveries.count).to eq 1
#             end

#             it "should render nothing" do
#                 expect(response.body).to be_blank
#             end
#         end
#     end
# end