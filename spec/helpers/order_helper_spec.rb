require 'rails_helper'

describe OrderHelper do

    describe '#status_label' do
        let(:dispatched) { create(:order, shipping_status: 'dispatched') }
        let(:completed) { create(:transaction) }
        let(:pending) { create(:transaction, payment_status: 'pending') }
        let(:failed) { create(:transaction, payment_status: 'failed') }

        context "if the status parameter value is 'Pending'" do

            it "should return a html_safe string with a 'Pending' status" do
                expect(helper.status_label(pending, pending.payment_status)).to eq "<span class='label label-orange label-small'>Pending</span>"
            end
        end

        context "if the status parameter value is 'Completed'" do

            it "should return a html_safe string with a 'Completed' status" do
                expect(helper.status_label(completed, completed.payment_status)).to eq "<span class='label label-green label-small'>Completed</span>"
            end
        end

        context "if the status parameter value is 'Dispatched'" do

            it "should return a html_safe string with a 'Dispatched' status" do
                expect(helper.status_label(dispatched, dispatched.shipping_status)).to eq "<span class='label label-green label-small'>Dispatched</span>"
            end
        end

        context "if it is neither 'Pending' or 'Completed'" do

            it "should return a html_safe string with a 'Failed' status" do
                expect(helper.status_label(failed, failed.payment_status)).to eq "<span class='label label-red label-small'>Failed</span>"
            end
        end
    end

    describe '#order_link' do
        let!(:cart) { create(:full_cart) }

        context "if the cart has an associated order" do
            let!(:order) { create(:order, cart_id: cart.id) }

            it "should return the order review path" do
                expect(order_link(cart)).to eq "/orders/#{order.id}/build/review"
            end
        end

        context "if the cart does not have an associated order" do

            it "should return the new order path" do
                expect(order_link(cart)).to eq '/orders/new'
            end
        end
    end
end