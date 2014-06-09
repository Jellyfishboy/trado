require 'spec_helper'

describe Payatron4000::Generic do

    describe "When creating a successful order" do
        let(:order) { create(:order, status: 'billing') }
        let(:successful_order) { Payatron4000::Generic.successful(order, nil)}
        before(:each) do
            unless example.metadata[:skip_before]
                successful_order
            end
        end

        it "should create a new transaction record", skip_before: true do
            expect{ 
                successful_order
            }.to change(Transaction, :count).by(1)
        end

        it "should update the order's status attribute to active" do
            expect(order.status).to eq 'active'
        end

        it "should set the payment status of the transaction to 'Pending'" do
            expect(order.transactions.first.payment_status).to eq 'Pending'
        end

        context "if the payment type is 'Cheque'" do
            let(:order) { create(:cheque_order) }

            it "should set the transaction payment type value to 'Cheque'" do
                Payatron4000::Generic.successful(order, 'Cheque')
                expect(order.transactions.first.payment_type).to eq 'Cheque'
            end
        end

        context "if the payment type is 'Bank transfer'" do
            let(:order) { create(:bank_transfer_order) }

            it "should set the transaction payment type value to 'Bank transfer'" do
                Payatron4000::Generic.successful(order, 'Bank transfer')
                expect(order.transactions.first.payment_type).to eq 'Bank transfer'
            end
        end
    end

    # describe "When completing an order" do
    #     let(:order) { create(:order) }
    #     let(:cart) { create(:cart) }
    #     let(:session) { Hash({:cart_id => cart.id}) }

    #     it "should redirect to the succesful order page" do
    #         expect(Payatron4000::Generic.complete(order, 'Cheque', session)).to redirect_to(success_order_build_url(:order_id => order.id, :id => 'confirm'))
    #     end
    # end

end