require 'spec_helper'

describe Admin::CategoriesController do

    describe 'GET #index' do
            it "populates an array of all categories" 
            it "renders the :index template"
    end

    describe 'GET #new' do
        it "assigns a new Category to @category" 
        it "renders the :new template"
    end

    describe 'GET #edit' do
        it "assigns the requested category to @category" 
        it "renders the :edit template"
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new category in the database"
            it "redirects to categorys#index" 
        end
        context "with invalid attributes" do
            it "does not save the new category in the database" 
            it "re-renders the :new template"
        end 
    end

    describe 'PATCH #update' do
        context "with valid attributes" do
            it "updates the category in the database"
            it "redirects to the category#index" 
        end
        context "with invalid attributes" do 
            it "does not update the category" 
            it "re-renders the #edit template"
        end 
    end
    
    describe 'DELETE #destroy' do
        it "deletes the category from the database" 
        it "redirects to category#index"
    end

end