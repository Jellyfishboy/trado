require 'rails_helper'

describe OrderMailer do

    store_setting

    describe 'completed' do
        let!(:order) { create(:addresses_complete_order) }
        let(:mail) { OrderMailer.completed(order) }

        it 'should render the subject' do
            expect(mail.subject).to eq "#{Store.settings.name} Order ##{order.id} Complete"
        end

        it 'should render the receiver email' do
            expect(mail.to).to eq [order.email]
        end

        it 'should render the from email' do
            expect(mail.from).to eq [Store.settings.email]
        end
    end

    describe 'pending' do
        let!(:order) { create(:addresses_complete_order) }
        let(:mail) { OrderMailer.pending(order) }

        it 'should render the subject' do
            expect(mail.subject).to eq "#{Store.settings.name} Order ##{order.id} Pending"
        end

        it 'should render the receiver email' do
            expect(mail.to).to eq [order.email]
        end

        it 'should render the from email' do
            expect(mail.from).to eq [Store.settings.email]
        end
    end

    describe 'failed' do
        let!(:order) { create(:addresses_complete_order) }
        let(:mail) { OrderMailer.failed(order) }

        it 'should render the subject' do
            expect(mail.subject).to eq "#{Store.settings.name} Order ##{order.id} Failed"
        end

        it 'should render the receiver email' do
            expect(mail.to).to eq [order.email]
        end

        it 'should render the from email' do
            expect(mail.from).to eq [Store.settings.email]
        end
    end

    describe 'dispatched' do
        let!(:order) { create(:addresses_complete_order) }
        let(:mail) { OrderMailer.dispatched(order) }

        it 'should render the subject' do
            expect(mail.subject).to eq "#{Store.settings.name} Order ##{order.id} Dispatched"
        end

        it 'should render the receiver email' do
            expect(mail.to).to eq [order.email]
        end

        it 'should render the from email' do
            expect(mail.from).to eq [Store.settings.email]
        end
    end

    describe 'updated_dispatched' do
        let!(:order) { create(:addresses_complete_order) }
        let(:mail) { OrderMailer.updated_dispatched(order) }

        it 'should render the subject' do
            expect(mail.subject).to eq "#{Store.settings.name} Order ##{order.id} Delivery Tracking"
        end

        it 'should render the receiver email' do
            expect(mail.to).to eq [order.email]
        end

        it 'should render the from email' do
            expect(mail.from).to eq [Store.settings.email]
        end
    end
end