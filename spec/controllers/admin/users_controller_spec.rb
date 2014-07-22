require 'rails_helper'

describe Admin::UsersController do

    store_setting
    login_admin

    describe 'GET #edit' do
        let(:user) { subject.send(:current_user) }

        it "should assign the current_user to @user" do
            get :edit
            expect(assigns(:user)).to eq user
        end

        context "if the user has an attachment" do
            let!(:admin) { create(:attached_admin) }
            before(:each) do
                subject.stub(:current_user).and_return(admin)
            end

            it "should assign @attachment to be nil" do
                get :edit
                expect(assigns(:attachment)).to eq nil
            end
        end

        context "if the user does not have an attachment" do

            it "should assign a new attachment to @attachment" do
                get :edit
                expect(assigns(:attachment)).to be_a_new(Attachment)
            end
        end
    end

    describe 'PATCH #update' do
        let(:user) { subject.send(:current_user) }

        it "should assign the current_user to @user" do
            patch :update, user: attributes_for(:user)
            expect(assigns(:user)).to eq user
        end 

        context "with valid attributes" do

            it "should update the user" do
                patch :update, user: attributes_for(:user, email: 'hehe@example.com')
                expect(user.email).to eq 'hehe@example.com'
            end

            it "should redirect the user to admin root" do
                patch :update, user: attributes_for(:user)
                expect(response).to redirect_to(admin_root_url)
            end
        end

        context "with invalid attributes" do

            it "should not update the user" do
                patch :update, user: attributes_for(:user, email: nil)
                expect(user.email).to eq user.email
            end

            it "should re-render the :edit template" do
                patch :update, user: attributes_for(:user, email: nil)
                expect(response).to render_template(:edit)
            end
        end
    end
end