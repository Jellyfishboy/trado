require 'rails_helper'

describe Admin::Zones::CountriesController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:country_1) { create(:country, name: 'argentina') }
        let!(:country_2) { create(:country, name: 'brazil') }

        it "should populate an array of all countries" do
            get :index
            expect(assigns(:countries)).to match_array([country_1, country_2])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "should assign a new Country to @country" do
            get :new
            expect(assigns(:country)).to be_a_new(Country)
        end
        it "should render the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:country) { create(:country) }

        it "should assign the requested country to @country" do
            get :edit , id: country.id
            expect(assigns(:country)).to eq country
        end
        it "should render the :edit template" do
            get :edit, id: country.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "should save the new country in the database" do
                expect {
                    post :create, country: attributes_for(:country)
                }.to change(Country, :count).by(1)
            end
            it "should redirect to countries#index"  do
                post :create, country: attributes_for(:country)
                expect(response).to redirect_to admin_zones_countries_url
            end
        end
        context "with invalid attributes" do
            it "should not save the new country in the database" do
                expect {
                    post :create, country: attributes_for(:invalid_country)
                }.to_not change(Country, :count)
            end
            it "should re-render the :new template" do
                post :create, country: attributes_for(:invalid_country)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        let!(:country) { create(:country, name: 'Country #1') }

        context "with valid attributes" do
            it "should locate the requested @country" do
                patch :update, id: country.id, country: attributes_for(:country)
                expect(assigns(:country)).to eq(country)
            end
            it "should update the country in the database" do
                patch :update, id: country.id, country: attributes_for(:country, name: 'Country #2')
                country.reload
                expect(country.name).to eq('Country #2')
            end
            it "should redirect to the countries#index" do
                patch :update, id: country.id, country: attributes_for(:country)
                expect(response).to redirect_to admin_zones_countries_url
            end
        end
        context "with invalid attributes" do 
            it "should not update the country" do
                patch :update, id: country.id, country: attributes_for(:country, name: nil)
                country.reload
                expect(country.name).to eq('Country #1')
            end
            it "should re-render the #edit template" do
                patch :update, id: country.id, country: attributes_for(:invalid_country)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:country) { create(:country) }
        
        context "if there is more than one country in the database" do
            before :each do
                create(:country)
            end

            it "should flash a success message" do
                delete :destroy, id: country.id
                expect(subject.request.flash[:success]).to_not be_nil
            end

            it "should delete the country from the database"  do
                expect {
                    delete :destroy, id: country.id
                }.to change(Country, :count).by(-1)
            end
        end

        context "if there is only one country in the database" do

            it "should flash a error message" do
                delete :destroy, id: country.id
                expect(subject.request.flash[:error]).to_not be_nil
            end

            it "should not delete the country from the database"  do
                expect {
                    delete :destroy, id: country.id
                }.to change(Country, :count).by(0)
            end
        end
        it "should redirect to countrys#index" do
            delete :destroy, id: country.id
            expect(response).to redirect_to admin_zones_countries_url
        end
    end

end