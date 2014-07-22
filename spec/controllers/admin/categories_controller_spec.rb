require 'rails_helper'

describe Admin::CategoriesController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:category_1) { create(:category) }
        let!(:category_2) { create(:category) }

        it "should populate an array of all categories" do
            get :index
            expect(assigns(:categories)).to match_array([category_1, category_2])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "should assign a new Category to @category" do
            get :new
            expect(assigns(:category)).to be_a_new(Category)
        end
        it "should render the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:category) { create(:category) }

        it "should assign the requested category to @category" do
            get :edit , id: category.id
            expect(assigns(:category)).to eq category
        end
        it "should render the :edit template" do
            get :edit, id: category.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "should save the new category in the database" do
                expect {
                    post :create, category: attributes_for(:category)
                }.to change(Category, :count).by(1)
            end
            it "should redirect to categories#index"  do
                post :create, category: attributes_for(:category)
                expect(response).to redirect_to admin_categories_url
            end
        end
        context "with invalid attributes" do
            it "should not save the new category in the database" do
                expect {
                    post :create, category: attributes_for(:invalid_category)
                }.to_not change(Category, :count)
            end
            it "should re-render the :new template" do
                post :create, category: attributes_for(:invalid_category)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        let!(:category) { create(:category, name: 'Category #1', visible: false) }

        context "with valid attributes" do
            it "should locate the requested @category" do
                patch :update, id: category.id, category: attributes_for(:category)
                expect(assigns(:category)).to eq(category)
            end
            it "should update the category in the database" do
                patch :update, id: category.id, category: attributes_for(:category, name: 'Category #2', visible: true)
                category.reload
                expect(category.name).to eq('Category #2')
                expect(category.visible).to eq(true)
            end
            it "should redirect to the categories#index" do
                patch :update, id: category.id, category: attributes_for(:category)
                expect(response).to redirect_to admin_categories_url
            end
        end
        context "with invalid attributes" do 
            it "should not update the category" do
                patch :update, id: category.id, category: attributes_for(:category, name: nil, visible: true)
                category.reload
                expect(category.name).to eq('Category #1')
                expect(category.visible).to eq(false)
            end
            it "should re-render the #edit template" do
                patch :update, id: category.id, category: attributes_for(:invalid_category)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:category) { create(:category) }
        
        context "if there is more than one category in the database" do
            before :each do
                create(:category)
            end

            it "should flash a success message" do
                delete :destroy, id: category.id
                expect(subject.request.flash[:success]).to_not be_nil
            end

            it "should delete the category from the database"  do
                expect {
                    delete :destroy, id: category.id
                }.to change(Category, :count).by(-1)
            end
        end

        context "if there is only one category in the database" do

            it "should flash a error message" do
                delete :destroy, id: category.id
                expect(subject.request.flash[:error]).to_not be_nil
            end

            it "should not delete the category from the database"  do
                expect {
                    delete :destroy, id: category.id
                }.to change(Category, :count).by(0)
            end
        end
        it "should redirect to categorys#index" do
            delete :destroy, id: category.id
            expect(response).to redirect_to admin_categories_url
        end
    end

end