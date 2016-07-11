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

    describe "#order_filter_classes" do

        context "if order is dispatched" do
            let!(:order) { create(:complete_order) }

            it "should render order-dispatched class" do
                expect(order_filter_classes(order)).to eq "order-dispatched"
            end
        end

        context "if order is not dispatched" do
            let!(:order) { create(:undispatched_complete_order) }

            it "should render order-pending class" do
                expect(order_filter_classes(order)).to eq "order-pending"
            end
        end
    end
end