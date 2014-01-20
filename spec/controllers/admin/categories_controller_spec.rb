require 'spec_helper'

describe Admin::CategoriesController do

    login_admin

    describe 'GET #index' do
            # it "populates an array of all categories" do
            #     category_1 = create(:category)
            #     category_2 = create(:category)
            #     get :index
            #     expect(assigns(:categories)).to match_array([category_1, category_2])
            # end
            it "renders the :index template" do
                get :index
                expect(response).to render_template :index
            end
    end

    describe 'GET #new' do
        it "assigns a new Category to @category" do
            get :new
            expect(assigns(:category)).to be_a_new(Category)
        end
        it "renders the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        it "assigns the requested category to @category" do
            category = create(:category)
            get :edit , id: category
            expect(assigns(:category)).to eq category
        end
        it "renders the :edit template" do
            category = create(:category)
            get :edit, id: category
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new category in the database" do
                expect {
                    post :create, category: attributes_for(:category)
                }.to change(Category, :count).by(1)
            end
            it "redirects to categories#index"  do
                post :create, category: attributes_for(:category)
                expect(response).to redirect_to admin_categories_url
            end
        end
        context "with invalid attributes" do
            it "does not save the new category in the database" do
                expect {
                    post :create, category: attributes_for(:invalid_category)
                }.to_not change(Category, :count)
            end
            it "re-renders the :new template" do
                post :create, category: attributes_for(:invalid_category)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        before :each do
            @category = create(:category, name: 'Category #1', visible: false)
        end
        context "with valid attributes" do
            it "locates the requested @category" do
                put :update, id: @category, category: attributes_for(:category)
                expect(assigns(:category)).to eq(@category)
            end
            it "updates the category in the database" do
                put :update, id: @category, category: attributes_for(:category, name: 'Category #2', visible: true)
                @category.reload
                expect(@category.name).to eq('Category #2')
                expect(@category.visible).to eq(true)
            end
            it "redirects to the categories#index" do
                put :update, id: @category, category: attributes_for(:category)
                expect(response).to redirect_to admin_categories_url
            end
        end
        context "with invalid attributes" do 
            it "does not update the category" do
                put :update, id: @category, category: attributes_for(:category, name: nil, visible: true)
                @category.reload
                expect(@category.name).to eq('Category #1')
                expect(@category.visible).to eq(false)
            end
            it "re-renders the #edit template" do
                put :update, id: @category, category: attributes_for(:invalid_category)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        before :each do
            @category = create(:category)
        end
        it "deletes the category from the database"  do
            expect {
                delete :destroy, id: @category
            }.to change(Category, :count).by(-1)
        end
        it "redirects to categories#index" do
            delete :destroy, id: @category
            expect(response).to redirect_to admin_categories_url
        end
    end

end