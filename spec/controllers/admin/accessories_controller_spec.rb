require 'spec_helper'

describe Admin::AccessoriesController do

    describe 'GET #index' do
            it "populates an array of all accessories" 
            it "renders the :index template"
    end

    describe 'GET #new' do
        it "assigns a new Accessory to @accessory" 
        it "renders the :new template"
    end

    describe 'GET #edit' do
        it "assigns the requested accessory to @accessory" 
        it "renders the :edit template"
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new accessory in the database"
            it "redirects to accessorys#index" 
        end
        context "with invalid attributes" do
            it "does not save the new accessory in the database" 
            it "re-renders the :new template"
        end 
    end

    describe 'PATCH #update' do
        context "with valid attributes" do
            it "updates the accessory in the database"
            it "redirects to the accessory#index" 
        end
        context "with invalid attributes" do 
            it "does not update the accessory" 
            it "re-renders the #edit template"
        end 
    end
    
    describe 'DELETE #destroy' do
        it "deletes the accessory from the database" 
        it "redirects to accessory#index"
    end

end