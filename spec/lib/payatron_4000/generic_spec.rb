# require 'rails_helper'

# describe Payatron4000::Generic do

#     store_setting

#     describe "When creating a successful order" do
#         let(:order) { create(:order) }
#         let(:successful_order) { Payatron4000::Generic.successful(order, nil)}
#         before(:each) do
#             unless RSpec.current_example.metadata[:skip_before]
#                 successful_order
#             end
#         end

#         it "should create a new transaction record", skip_before: true do
#             expect{ 
#                 successful_order
#             }.to change(Transaction, :count).by(1)
#         end


#         it "should set the payment status of the transaction to 'Pending'" do
#             expect(order.transactions.first.payment_status).to eq 'pending'
#         end

#         context "if the payment type is 'Cheque'" do
#             let(:order) { create(:cheque_order) }

#             it "should set the transaction payment type value to 'Cheque'" do
#                 Payatron4000::Generic.successful(order, 'Cheque')
#                 expect(order.transactions.first.payment_type).to eq 'Cheque'
#             end
#         end

#         context "if the payment type is 'Bank transfer'" do
#             let(:order) { create(:bank_transfer_order) }

#             it "should set the transaction payment type value to 'Bank transfer'" do
#                 Payatron4000::Generic.successful(order, 'Bank transfer')
#                 expect(order.transactions.first.payment_type).to eq 'Bank transfer'
#             end
#         end
#     end

#     describe "When completing an order" do
#         let(:order) { create(:addresses_order) }
#         let(:cart) { create(:cart) }
#         let(:session) { Hash({:cart_id => cart.id}) }
#         let(:successful_order) { Payatron4000::Generic.complete(order, 'Cheque', session) }

#         it "should create a new transaction record" do
#             expect{
#                 successful_order
#             }.to change(Transaction, :count).by(1)
#         end

#         it "should result in an email being sent" do
#             expect{
#                 successful_order
#             }.to change {
#                 ActionMailer::Base.deliveries.count }.by(1)
#         end

#         it "should return a redirect URL to the succesful order page" do
#             expect(successful_order).to eq "http://localhost:3000/orders/#{order.id}/success"
#         end
#     end

# end