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

    describe '#selected_country' do
        let!(:cart) { create(:cart) }

        context "if the order_address parameter is nil" do

            it "should return the country attribute from the cart parameter" do
                expect(selected_country(cart, nil)).to eq cart.country
            end
        end

        context "if the order_address parameter is not nil" do

            it "should return the order_address parameter" do
                expect(selected_country(cart, 'United Kingdom')).to eq 'United Kingdom'
            end
        end
    end
end