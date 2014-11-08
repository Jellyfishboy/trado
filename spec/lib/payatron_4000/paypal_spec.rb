require 'rails_helper'

describe Payatron4000::Paypal do

    store_setting

    describe "When building an order ready for PayPal authentication" do
        let(:cart) { create(:cart) }
        let(:order) { create(:order, cart_id: cart.id) }
        let(:failed_build) { Payatron4000::Paypal.build(cart, order, '127.0.0.123') }
        before(:each) do
            EXPRESS_GATEWAY.stub(:setup_purchase) { OpenStruct.new( :message => 'Failed order.', 
                                                                    :params => { 'error_codes' => 14012 },
                                                                    :success? => false
                                                                )
                                                }
        end

        context "if the PayPal response was unsuccessful" do

            it "should save a failed transaction record to the database" do
                expect{
                    failed_build
                }.to change(Transaction, :count).by(1)
            end

            it "should decommission the order" do
                expect{
                    failed_build
                }.to change{
                    order.cart_id
                }.from(cart.id).to(nil)
            end

            it "should return the failed order url" do
                expect(failed_build).to eq "http://localhost:3000/orders/#{order.id}/failed"
            end
        end
    end

    describe "When requesting an order object for reviewal in PayPal" do
        let(:order) { create(:order, net_amount: '12.5', tax_amount: '4.56') }
        let(:steps) { ['review', 'billing', 'shipping', 'payment', 'confirm'] }
        let(:cart) { create(:cart) }
        let(:ip_address) { "10.1.5.25" }
        let(:return_url) { "/return_url" }
        let(:cancel_url) { "/cancel_url" }
        let(:express_options) { Payatron4000::Paypal.express_setup_options(order, cart, ip_address, return_url, cancel_url) }

        it "should set the correct subtotal" do
            expect(express_options[:subtotal]).to eq (1250)
        end

        it "should set the correct tax" do
            expect(express_options[:tax]).to eq 456
        end

        it "should set the correct order id" do
            expect(express_options[:order_id]).to eq order.id
        end

        it "should set the correct ip address" do
            expect(express_options[:ip]).to eq "10.1.5.25"
        end

        it "should set the correct return url" do
            expect(express_options[:return_url]).to eq "/return_url"
        end

        it "should set the correct cancel url" do
            expect(express_options[:cancel_return_url]).to eq "/cancel_url"
        end
    end

    describe "When requesting an order object for confirming an order in PayPal" do
        let(:order) { create(:order, express_token: 'TAD623452', express_payer_id: '3622', tax_amount: '6.43', net_amount: '89.23') }
        let(:express_purchase) { Payatron4000::Paypal.express_purchase_options(order) }

        it "should set the correct subtotal" do
            expect(express_purchase[:subtotal]).to eq (8923)
        end

        it "should set the correct tax" do
            expect(express_purchase[:tax]).to eq 643
        end

        it "should set the correct express token" do
            expect(express_purchase[:token]).to eq 'TAD623452'
        end

        it "should set the correct payer id" do
            expect(express_purchase[:payer_id]).to eq '3622'
        end
    end

    describe "When creating an array of cart items for PayPal" do
        let!(:cart) { create(:cart) }
        let!(:cart_item_1) { create(:cart_item, cart: cart) }
        let!(:cart_item_2) { create(:cart_item, cart: cart) }
        let!(:cart_item_accessory) { create(:cart_item_accessory, cart_item: cart_item_2) }
        let(:express_items) { Payatron4000::Paypal.express_items(cart) }

        it "should set the correct product name" do
            expect(express_items[0][:name]).to eq cart_item_2.sku.product.name
            expect(express_items[1][:name]).to eq cart_item_1.sku.product.name
        end

        it "should set the correct description" do
            expect(express_items[0][:description]).to eq cart_item_2.sku.attribute_value.to_s
            expect(express_items[1][:description]).to eq cart_item_1.sku.attribute_value.to_s
        end

        it "should set the correct amount" do
            expect(express_items[0][:amount]).to eq Store::Price.new(price: cart_item_2.price, tax_type: 'net').singularize
            expect(express_items[1][:amount]).to eq Store::Price.new(price: cart_item_1.price, tax_type: 'net').singularize
        end

        it "should set the correct quantity" do
            expect(express_items[0][:quantity]).to eq cart_item_2.quantity
            expect(express_items[1][:quantity]).to eq cart_item_1.quantity
        end
    end

    describe "When assigning PayPal details to order record" do
        let(:order) { create(:order) }
        let(:token) { "TAD3227" }
        let(:payer_id) { "7327" }
        before(:each) do
            Payatron4000::Paypal.assign_paypal_token(token, payer_id, order)
        end

        it "should update the order with a token" do
            expect(order.express_token).to eq token
        end

        it "should update the order with a payer id" do
            expect(order.express_payer_id).to eq payer_id
        end
    end

    describe "When completing an order" do

        context "if the payment was successful" do
            let!(:order) { create(:addresses_order) }
            let(:session) { Hash({:cart_id => order.cart.id}) }
            let(:successful_order) { Payatron4000::Paypal.complete(order, session) }
            before(:each) do
                EXPRESS_GATEWAY.stub(:purchase) { OpenStruct.new(  :params => { 'PaymentInfo' => {  'FeeAmount' => '2.34', 
                                                                                                    'TransactionID' => '78232', 
                                                                                                    'GrossAmount' => '67.23',
                                                                                                    'PaymentStatus' => 'Completed',
                                                                                                    'TaxAmount' => '15.66',
                                                                                                    'TransactionType' => 'express-checkout',
                                                                                                    'PendingReason' => nil 
                                                                                                }
                                                                                },
                                                                                :success? => true 
                                                                )
                                                }
            end

            it "should create a tranasction record" do
                expect{
                    successful_order
                }.to change(Transaction, :count).by(1)
            end

            it "should destroy a cart record" do
                expect{
                    successful_order
                }.to change(Cart, :count).by(-1)
            end

            it "should result in an email being sent" do
                expect{
                    successful_order
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end

            it "should return a redirect URL to the succesful order page" do
                expect(successful_order).to eq "http://localhost:3000/orders/#{order.id}/success"
            end
            
        end

        context "if the payment was unsuccessful" do

            let!(:cart) { create(:cart) }
            let(:session) { Hash({:cart_id => cart.id}) }
            let(:order) { create(:addresses_order) }
            let(:failed_order) { Payatron4000::Paypal.complete(order, session) }
            before(:each) do
                EXPRESS_GATEWAY.stub(:purchase) { OpenStruct.new(  :params => { 'PaymentInfo' => {  'FeeAmount' => '', 
                                                                                                    'TransactionID' => '', 
                                                                                                    'GrossAmount' => '',
                                                                                                    'PaymentStatus' => 'Failed',
                                                                                                    'TaxAmount' => '',
                                                                                                    'TransactionType' => '',
                                                                                                    'PendingReason' => nil 
                                                                                                },
                                                                                'error_codes' => 14012
                                                                                },
                                                                                :success? => false 
                                                                )
                                                }
            end

            it "should create a tranasction record" do
                expect{
                    failed_order
                }.to change(Transaction, :count).by(1)
            end

            it "should result in an email being sent" do
                expect{
                    failed_order
                }.to change {
                    ActionMailer::Base.deliveries.count }.by(1)
            end

            it "should return a redirect URL to the failed order page" do
                expect(failed_order).to eq "http://localhost:3000/orders/#{order.id}/failed"
            end
        end
    end

    describe "Successful order" do
        let(:order) { create(:order) }
        let(:response) { OpenStruct.new(:params => { 'PaymentInfo' => { 'FeeAmount' => '2.34', 
                                                                        'TransactionID' => '78232', 
                                                                        'GrossAmount' => '67.23',
                                                                        'PaymentStatus' => 'Completed',
                                                                        'TaxAmount' => '15.66',
                                                                        'TransactionType' => 'express-checkout',
                                                                        'PendingReason' => nil 
                                                                    },
                                                    }
                                        )  
                        }
        let(:successful) { Payatron4000::Paypal.successful(response, order) }
        before(:each) do
            unless RSpec.current_example.metadata[:skip_before]
                successful
            end
        end

        it "should create a successful transaction", skip_before: true do
            expect{
                successful
            }.to change(Transaction, :count).by(1)
        end

        it "should set the correct fee amount for the transaction" do
            expect(order.transactions.first.fee).to eq BigDecimal.new("2.34")
        end

        it "should set the transaction record payment status attribute as 'Completed'" do
            expect(order.transactions.first.payment_status).to eq 'completed'
        end

        it "should set the correct paypal id for the transaction" do
            expect(order.transactions.first.paypal_id).to eq '78232'
        end

        it "should set the correct gross amount for the transaction" do
            expect(order.transactions.first.gross_amount).to eq BigDecimal.new("67.23")
        end
    end

    describe "Failed order" do

        let(:order) { create(:order, tax_amount: '7.44') }
        let(:response) { OpenStruct.new(:message => 'Failed order.', :params => { 'error_codes' => 14012 }) }
        let(:failed) { Payatron4000::Paypal.failed(response, order) }
        before(:each) do
            unless RSpec.current_example.metadata[:skip_before]
                failed
            end
        end


        it "should create a transaction record", skip_before: true do
            expect{
                failed
            }.to change(Transaction, :count).by(1)
        end

        it "should set the correct tax amount" do
            expect(order.transactions.first.tax_amount).to eq BigDecimal.new("7.44")
        end

        it "should set the payment type as 'express-checkout'" do
            expect(order.transactions.first.payment_type).to eq 'express-checkout'
        end

        it "should set the transaction record payment status attribute as 'Failed'" do
            expect(order.transactions.first.payment_status).to eq 'failed'
        end

        it "should set the correct value for the status reason attribute on the transaction record" do
            expect(order.transactions.first.status_reason).to eq 'Failed order.'
        end
    end
end