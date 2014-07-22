require 'rails_helper'

describe Admin::Products::Skus::AttributeTypesController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:attribute_type_1) { create(:attribute_type, name: 'weight') }
        let!(:attribute_type_2) { create(:attribute_type, name: 'colour') }

        it "should populate an array of all attribute_types" do
            get :index
            expect(assigns(:attribute_types)).to match_array([attribute_type_1, attribute_type_2])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "should assign a new AttributeType to @attribute_type" do
            get :new
            expect(assigns(:attribute_type)).to be_a_new(AttributeType)
        end
        it "should render the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:attribute_type) { create(:attribute_type) }

        it "should assign the requested attribute_type to @attribute_type" do
            get :edit , id: attribute_type.id
            expect(assigns(:attribute_type)).to eq attribute_type
        end
        it "should render the :edit template" do
            get :edit, id: attribute_type.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "should save the new attribute_type in the database" do
                expect {
                    post :create, attribute_type: attributes_for(:attribute_type)
                }.to change(AttributeType, :count).by(1)
            end
            it "should redirect to attribute_types#index"  do
                post :create, attribute_type: attributes_for(:attribute_type)
                expect(response).to redirect_to admin_products_skus_attribute_types_url
            end
        end
        context "with invalid attributes" do
            it "should not save the new attribute_type in the database" do
                expect {
                    post :create, attribute_type: attributes_for(:invalid_attribute_type)
                }.to_not change(AttributeType, :count)
            end
            it "should re-render the :new template" do
                post :create, attribute_type: attributes_for(:invalid_attribute_type)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        let!(:attribute_type) { create(:attribute_type, name: 'AttributeType #1') }

        context "with valid attributes" do
            it "should locate the requested @attribute_type" do
                patch :update, id: attribute_type.id, attribute_type: attributes_for(:attribute_type)
                expect(assigns(:attribute_type)).to eq(attribute_type)
            end
            it "should update the attribute_type in the database" do
                patch :update, id: attribute_type.id, attribute_type: attributes_for(:attribute_type, name: 'AttributeType #2')
                attribute_type.reload
                expect(attribute_type.name).to eq('AttributeType #2')
            end
            it "should redirect to the attribute_types#index" do
                patch :update, id: attribute_type.id, attribute_type: attributes_for(:attribute_type)
                expect(response).to redirect_to admin_products_skus_attribute_types_url
            end
        end
        context "with invalid attributes" do 
            it "should not update the attribute_type" do
                patch :update, id: attribute_type.id, attribute_type: attributes_for(:attribute_type, name: nil)
                attribute_type.reload
                expect(attribute_type.name).to eq('AttributeType #1')
            end
            it "should re-render the #edit template" do
            patch :update, id: attribute_type.id, attribute_type: attributes_for(:invalid_attribute_type)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:attribute_type) { create(:attribute_type) }
        
        context "if there is more than one attribute_type in the database" do
            before :each do
                create(:attribute_type)
            end

            it "should flash a success message" do
                delete :destroy, id: attribute_type.id
                expect(subject.request.flash[:success]).to_not be_nil
            end

            it "should delete the attribute_type from the database"  do
                expect {
                    delete :destroy, id: attribute_type.id
                }.to change(AttributeType, :count).by(-1)
            end
        end

        context "if there is only one attribute_type in the database" do

            it "should flash a error message" do
                delete :destroy, id: attribute_type.id
                expect(subject.request.flash[:error]).to_not be_nil
            end

            it "should not delete the attribute_type from the database"  do
                expect {
                    delete :destroy, id: attribute_type.id
                }.to change(AttributeType, :count).by(0)
            end
        end
        it "should redirect to attribute_types#index" do
            delete :destroy, id: attribute_type.id
            expect(response).to redirect_to admin_products_skus_attribute_types_url
        end
    end

end