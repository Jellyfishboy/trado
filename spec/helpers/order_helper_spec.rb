require 'rails_helper'

describe OrderHelper do

    describe '#shipping_status' do
        let(:dispatched) { create(:order, shipping_status: 'Dispatched') }
        let(:pending) { create(:order) }

        context "if the status parameter value is 'Pending'" do

            it "should return a html_safe string with a 'Pending' status" do
                expect(helper.shipping_status(pending.shipping_status)).to eq "<span class='label label-orange label-small'>Pending</span>"
            end
        end

        context "if the status parameter value is 'Dispatched'" do

            it "should return a html_safe string with a 'Dispatched' status" do
                expect(helper.shipping_status(dispatched.shipping_status)).to eq "<span class='label label-green label-small'>Dispatched</span>"
            end
        end
    end

    describe '#shipping_status' do
        let(:completed) { create(:transaction) }
        let(:pending) { create(:transaction, payment_status: 'Pending') }
        let(:failed) { create(:transaction, payment_status: 'Failed') }

        context "if the status parameter value is 'Pending'" do

            it "should return a html_safe string with a 'Pending' status" do
                expect(helper.payment_status(pending.payment_status)).to eq "<span class='label label-orange label-small'>Pending</span>"
            end
        end

        context "if the status parameter value is 'Completed'" do

            it "should return a html_safe string with a 'Completed' status" do
                expect(helper.payment_status(completed.payment_status)).to eq "<span class='label label-green label-small'>Completed</span>"
            end
        end

        context "if it is neither 'Pending' or 'Completed'" do

            it "should return a html_safe string with a 'Failed' status" do
                expect(helper.payment_status(failed.payment_status)).to eq "<span class='label label-red label-small'>Failed</span>"
            end
        end
    end
end