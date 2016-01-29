require 'rails_helper'

describe P::PagesController do

    store_setting

    describe 'GET #standard' do
        let!(:page) { create(:standard_page) }

        it 'should assign the requested page to @page' do
            get :show, slug: page.slug
            expect(assigns(:page)).to eq page
        end

        it "should render the :standard template" do
            get :show, slug: page.slug
            expect(response).to render_template :standard
        end
    end

    describe 'GET #contact' do
        let!(:page) { create(:contact_page) }

        it 'should assign the requested page to @page' do
            get :show, slug: page.slug
            expect(assigns(:page)).to eq page
        end

        it 'should render the :contact template' do
            get :show, slug: page.slug
            expect(response).to render_template :contact
        end
    end 

    describe 'POST #send_contact_message' do
        context "with valid attributes" do
            
            it "should send a new email", broken: true do
                expect{
                    xhr :post, :send_contact_message, contact_message: attributes_for(:contact_message)
                }.to change {
                    ActionMailer::Base.deliveries.count
                }.by(1)
            end

            it "should render the success partial" do
                xhr :post, :send_contact_message, contact_message: attributes_for(:contact_message)
                expect(response).to render_template(partial: "themes/#{Store.settings.theme.name}/pages/contact_message/_success")
            end
        end

        context "with invalid attributes" do
            let(:errors) { "{\"email\":[\"is required\",\"is invalid\"]}" }

            it "should not send a new email" do
                expect{
                    xhr :post, :send_contact_message, contact_message: attributes_for(:invalid_contact_message)
                }.to_not change {
                    ActionMailer::Base.deliveries.count
                }
            end

            it "should return a JSON object of errors" do
                xhr :post, :send_contact_message, contact_message: attributes_for(:invalid_contact_message)
                expect(assigns(:contact_message).errors.to_json(root: true)).to eq errors
            end

            it "should return a 422 status code" do
                xhr :post, :send_contact_message, contact_message: attributes_for(:invalid_contact_message)
                expect(response.status).to eq 422
            end
        end
    end
end