require 'rails_helper'

describe NotificationsController do

    store_setting

    describe 'POST #create' do

        context "with valid attributes" do
            
            it "should save a new notification to the database" do
                expect{
                    xhr :post, :create, notification: attributes_for(:notification)
                }.to change(Notification, :count).by(1)
            end

            it "should render the success partial" do
                xhr :post, :create, notification: attributes_for(:notification)
                expect(response).to render_template(partial: 'products/notify/_success')
            end
        end

        context "with invalid attributes" do
            let(:errors) { "{\"email\":[\"can't be blank\",\"is invalid\"]}" }

            it "should not save the notification to the database" do
                expect{
                    xhr :post, :create, notification: attributes_for(:notification, email: nil)
                }.to_not change(Notification, :count)
            end

            it "should return a JSON object of errors" do
                xhr :post, :create, notification: attributes_for(:notification, email: nil)
                expect(assigns(:notification).errors.to_json(root: true)).to eq errors
            end
        end
    end
end