require 'spec_helper'

describe Admin::TiersController do

    describe 'GET #index' do
            it "populates an array of all tiers" 
            it "renders the :index template"
    end

    describe 'GET #new' do
        it "assigns a new Tier to @tier" 
        it "renders the :new template"
    end

    describe 'GET #edit' do
        it "assigns the requested tier to @tier" 
        it "renders the :edit template"
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new tier in the database"
            it "redirects to tiers#index" 
        end
        context "with invalid attributes" do
            it "does not save the new tier in the database" 
            it "re-renders the :new template"
        end 
    end

    describe 'PATCH #update' do
        context "with valid attributes" do
            it "updates the tier in the database"
            it "redirects to the tier#index" 
        end
        context "with invalid attributes" do 
            it "does not update the tier" 
            it "re-renders the #edit template"
        end 
    end
    
    describe 'DELETE #destroy' do
        it "deletes the tier from the database" 
        it "redirects to tier#index"
    end

end