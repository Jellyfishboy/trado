require 'spec_helper'

describe Admin::CountriesController do

    describe 'GET #index' do
            it "populates an array of all countries" 
            it "renders the :index template"
    end

    describe 'GET #new' do
        it "assigns a new Country to @country" 
        it "renders the :new template"
    end

    describe 'GET #edit' do
        it "assigns the requested country to @country" 
        it "renders the :edit template"
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new country in the database"
            it "redirects to countrys#index" 
        end
        context "with invalid attributes" do
            it "does not save the new country in the database" 
            it "re-renders the :new template"
        end 
    end

    describe 'PATCH #update' do
        context "with valid attributes" do
            it "updates the country in the database"
            it "redirects to the country#index" 
        end
        context "with invalid attributes" do 
            it "does not update the country" 
            it "re-renders the #edit template"
        end 
    end
    
    describe 'DELETE #destroy' do
        it "deletes the country from the database" 
        it "redirects to country#index"
    end

end