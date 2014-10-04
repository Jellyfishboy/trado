require 'rails_helper'

describe PagesController do

    store_setting

    describe 'GET #standard' do
        let!(:page) { create(:standard_page) }
        before(:each) do
            DynamicRouter.load
        end

        it 'should assign the requested page to @page' do
            get :standard, id: page.id
            expect(assigns(:page)).to eq page
        end

        it "should render the :standard template" do
            get :standard, id: page.id
            expect(response).to render_template :standard
        end
    end

    describe 'GET #contact' do
        let!(:page) { create(:contact_page) }
        before(:each) do
            DynamicRouter.load
        end

        it 'should assign the requested page to @page' do
            get :contact, id: page.id
            expect(assigns(:page)).to eq page
        end

        it 'should render the :contact template' do
            get :contact, id: page.id
            expect(response).to render_template :contact
        end
    end 

    # describe 'POST #send_contact_message' do
    #     context "with valid attributes" do
            
    #         it "should send a new email" do
    #             expect{
    #                 xhr :post, :send_contact_message, contact: attributes_for(:contact_message)
    #             }.to change {
    #                 ActionMailer::Base.deliveries.count
    #             }.by(1)
    #         end

    #         it "should render the success partial" do
    #             xhr :post, :send_contact_message, contact: attributes_for(:contact_message)
    #             expect(response).to render_template(partial: 'pages/contact_message/_success')
    #         end
    #     end

    #     context "with invalid attributes" do
    #         let(:errors) { "{\"email\":[\"is required\",\"is invalid\"]}" }

    #         it "should not send a new email" do
    #             expect{
    #                 xhr :post, :send_contact_message, contact: attributes_for(:invalid_contact_message)
    #             }.to_not change {
    #                 ActionMailer::Base.deliveries.count
    #             }
    #         end

    #         it "should return a JSON object of errors" do
    #             xhr :post, :send_contact_message, contact: attributes_for(:invalid_contact_message)
    #             expect(assigns(:contact).errors.to_json(root: true)).to eq errors
    #         end

    #         it "should return a 422 status code" do
    #             xhr :post, :send_contact_message, contact: attributes_for(:invalid_contact_message)
    #             expect(response.status).to eq 422
    #         end
    #     end
    # end
end