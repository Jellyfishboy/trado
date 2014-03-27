require 'spec_helper'

describe Admin::CountriesController do

    login_admin

    describe 'GET #index' do
        it "populates an array of all countries" do
            country_1 = create(:country)
            country_2 = create(:country)
            get :index
            expect(assigns(:countries)).to match_array([country_1, country_2])
        end
        it "renders the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "assigns a new Country to @country" do
            get :new
            expect(assigns(:country)).to be_a_new(Country)
        end
        it "renders the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        it "assigns the requested country to @country" do
            country = create(:country)
            get :edit , id: country
            expect(assigns(:country)).to eq country
        end
        it "renders the :edit template" do
            country = create(:country)
            get :edit, id: country
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new country in the database" do
                expect {
                    post :create, country: attributes_for(:country)
                }.to change(Country, :count).by(1)
            end
            it "redirects to countries#index"  do
                post :create, country: attributes_for(:country)
                expect(response).to redirect_to admin_countries_url
            end
        end
        context "with invalid attributes" do
            it "does not save the new country in the database" do
                expect {
                    post :create, country: attributes_for(:invalid_country)
                }.to_not change(Country, :count)
            end
            it "re-renders the :new template" do
                post :create, country: attributes_for(:invalid_country)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        before :each do
            @country = create(:country, name: 'Country #1')
        end
        context "with valid attributes" do
            it "locates the requested @country" do
                put :update, id: @country, country: attributes_for(:country)
                expect(assigns(:country)).to eq(@country)
            end
            it "updates the country in the database" do
                put :update, id: @country, country: attributes_for(:country, name: 'Country #2')
                @country.reload
                expect(@country.name).to eq('Country #2')
            end
            it "redirects to the countries#index" do
                put :update, id: @country, country: attributes_for(:country)
                expect(response).to redirect_to admin_countries_url
            end
        end
        context "with invalid attributes" do 
            it "does not update the country" do
                put :update, id: @country, country: attributes_for(:invalid_country)
                @country.reload
                expect(@country.name).to eq('Country #1')
            end
            it "re-renders the #edit template" do
                put :update, id: @country, country: attributes_for(:invalid_country)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        before :each do
            @country = create(:country)
        end
        it "deletes the country from the database"  do
            expect {
                delete :destroy, id: @country
            }.to change(Country, :count).by(-1)
        end
        it "redirects to countries#index" do
            delete :destroy, id: @country
            expect(response).to redirect_to admin_countries_url
        end
    end

end