require 'spec_helper'

describe Admin::AccessoriesController do

    describe 'GET #index' do
        context 'with params[:letter]' do
            it "populates an array of contacts starting with the letter"
            it "renders the :index template" 
        end
        context 'without params[:letter]' do
            it "populates an array of all contacts" 
            it "renders the :index template"
        end 
    end

    describe 'GET #new' do
        it "assigns a new Contact to @contact" 
        it "renders the :new template"
    end

    describe 'GET #edit' do
        it "assigns the requested contact to @contact" 
        it "renders the :edit template"
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new contact in the database"
        end
    end
end