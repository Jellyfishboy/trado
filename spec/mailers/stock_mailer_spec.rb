require 'rails_helper'

describe StockMailer do

    store_setting

    describe 'notification' do
        let(:sku) { create(:sku) }
        let(:user) { create(:user) }
        let(:mail) { StockMailer.notification(sku, user.email) }

        it 'should render the subject' do
            expect(mail.subject).to eq "#{sku.product.name} Stock Reminder"
        end

        it 'should render the receiver email' do
            expect(mail.to).to eq [user.email]
        end

        it 'should render the from email' do
            expect(mail.from).to eq [Store.settings.email]
        end
    end
end