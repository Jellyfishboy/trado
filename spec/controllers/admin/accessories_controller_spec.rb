require 'spec_helper'

describe Admin::AccessoriesController do

    login_admin

    describe 'GET #index' do
            it "populates an array of all accessories" do
                accessory_1 = create(:accessory)
                accessory_2 = create(:accessory)
                get :index
                expect(assigns(:accessories)).to match_array([accessory_1, accessory_2])
            end
            it "renders the :index template" do
                get :index
                expect(response).to render_template :index
            end
    end

    describe 'GET #new' do
        it "assigns a new Accessory to @accessory" do
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
            get :edit , id: accessory
            expect(assigns(:accessory)).to eq accessory
        end
        it "renders the :edit template" do
            accessory = create(:accessory)
            get :edit, id: accessory
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
            @accessory = create(:accessory, name: 'Accessory #1', part_number: 123)
        end
        context "with valid attributes" do
            it "locates the requested @accessory" do
                put :update, id: @accessory, accessory: attributes_for(:accessory)
                expect(assigns(:accessory)).to eq(@accessory)
            end
            it "updates the accessory in the database" do
                put :update, id: @accessory, accessory: attributes_for(:accessory, name: 'Accessory #2', part_number: 496)
                @accessory.reload
                expect(@accessory.name).to eq('Accessory #2')
                expect(@accessory.part_number).to eq(496)
            end
            it "redirects to the accessories#index" do
                put :update, id: @accessory, accessory: attributes_for(:accessory)
                expect(response).to redirect_to admin_accessories_url
            end
        end
        context "with invalid attributes" do 
            it "does not update the accessory" do
                put :update, id: @accessory, accessory: attributes_for(:accessory, name: 'Accessory #2', part_number: nil)
                @accessory.reload
                expect(@accessory.name).to eq('Accessory #1')
                expect(@accessory.part_number).to eq(123)
            end
            it "re-renders the #edit template" do
                put :update, id: @accessory, accessory: attributes_for(:invalid_accessory)
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
                delete :destroy, id: @accessory
            }.to change(Accessory, :count).by(-1)
        end
        it "redirects to accessories#index" do
            delete :destroy, id: @accessory
            expect(response).to redirect_to admin_accessories_url
        end
    end

end