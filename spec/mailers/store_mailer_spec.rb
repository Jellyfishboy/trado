require 'rails_helper'

describe StoreMailer do

    store_setting

    describe 'contact_message' do
        let(:params) { { :name => 'Tom Dallimore', :email => 'me@tomdallimore.com', :website => 'www.tomdallimore.com', :message => 'Hello, its me!' } }
        let(:mail) { StoreMailer.contact_message(params) }

        it 'should render the subject' do
            expect(mail.subject).to eq "New message from #{params[:name]}"
        end

        it 'should render the receiver email' do
            expect(mail.to).to eq [Store.settings.email]
        end

        it 'should render the from email' do
            expect(mail.from).to eq [params[:email]]
        end
    end
end