require 'rails_helper'

describe Admin::AccessoriesController do

    store_setting
    login_admin

    describe 'GET #index' do
        it "populates an array of active accessories" do
            accessory_1 = create(:accessory, active: false)
            accessory_2 = create(:accessory, active: true)
            accessory_3 = create(:accessory, active: true)
            get :index
            expect(assigns(:accessories)).to match_array([accessory_2, accessory_3])
        end
        it "renders the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "assigns a new accessory to @accessory" do
            get :new
            expect(assigns(:accessory)).to be_a_new(Accessory)
        end
        it "renders the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        it "assigns the requested accessory to @accessory" do
            accessory = create(:accessory)
            get :edit , id: accessory.id
            expect(assigns(:form_accessory)).to eq accessory
        end
        it "renders the :edit template" do
            accessory = create(:accessory)
            get :edit, id: accessory.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new accessory in the database" do
                expect {
                    post :create, accessory: attributes_for(:accessory)
                }.to change(Accessory, :count).by(1)
            end
            it "redirects to accessories#index"  do
                post :create, accessory: attributes_for(:accessory)
                expect(response).to redirect_to admin_accessories_url
            end
        end
        context "with invalid attributes" do
            it "does not save the new accessory in the database" do
                expect {
                    post :create, accessory: attributes_for(:invalid_accessory)
                }.to_not change(Accessory, :count)
            end
            it "re-renders the :new template" do
                post :create, accessory: attributes_for(:invalid_accessory)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        before :each do
            @accessory = create(:accessory, name: 'accessory #1')
        end
        context "with valid attributes" do
            it "locates the requested @accessory" do
                put :update, id: @accessory.id, accessory: attributes_for(:accessory)
                expect(assigns(:accessory)).to eq(@accessory)
            end
            it "updates the accessory in the database" do
                put :update, id: @accessory.id, accessory: attributes_for(:accessory, name: 'accessory #2')
                @accessory.reload
                expect(@accessory.name).to eq('accessory #2')
            end
            it "redirects to the accessories#index" do
                put :update, id: @accessory.id, accessory: attributes_for(:accessory)
                expect(response).to redirect_to admin_accessories_url
            end
        end
        context "with invalid attributes" do 
            it "does not update the accessory" do
                put :update, id: @accessory.id, accessory: attributes_for(:invalid_accessory)
                @accessory.reload
                expect(@accessory.name).to eq('accessory #1')
            end
            it "re-renders the #edit template" do
                put :update, id: @accessory.id, accessory: attributes_for(:invalid_accessory)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        before :each do
            @accessory = create(:accessory)
        end
        it "deletes the accessory from the database"  do
            expect {
                delete :destroy, id: @accessory.id
            }.to change(Accessory, :count).by(-1)
        end
        it "redirects to accessories#index" do
            delete :destroy, id: @accessory.id
            expect(response).to redirect_to admin_accessories_url
        end
    end
end