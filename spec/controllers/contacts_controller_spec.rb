require 'rails_helper'

describe ContactsController do

    store_setting

    describe 'GET #new' do

        it "should render the :new template" do
            get :new
            expect(response).to render_template 'store/contact'
        end
    end

    describe 'POST #create' do
        context "with valid attributes" do
            
            it "should send a new email" do
                expect{
                    xhr :post, :create, contact: attributes_for(:contact)
                }.to change {
                    ActionMailer::Base.deliveries.count
                }.by(1)
            end

            it "should render the success partial" do
                xhr :post, :create, contact: attributes_for(:contact)
                expect(response).to render_template(partial: 'store/contact/_success')
            end
        end

        context "with invalid attributes" do
            let(:errors) { "{\"email\":[\"is required\",\"is invalid\"]}" }

            it "should not send a new email" do
                expect{
                    xhr :post, :create, contact: attributes_for(:invalid_contact)
                }.to_not change {
                    ActionMailer::Base.deliveries.count
                }
            end

            it "should return a JSON object of errors" do
                xhr :post, :create, contact: attributes_for(:invalid_contact)
                expect(assigns(:contact).errors.to_json(root: true)).to eq errors
            end

            it "should return a 422 status code" do
                xhr :post, :create, contact: attributes_for(:invalid_contact)
                expect(response.status).to eq 422
            end
        end
    end
end