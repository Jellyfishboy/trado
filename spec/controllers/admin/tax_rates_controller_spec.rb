require 'spec_helper'

describe Admin::TaxRatesController do

    login_admin

    describe 'GET #index' do
        it "populates an array of active tax_rates" do
            tax_rate_1 = create(:tax_rate)
            tax_rate_2 = create(:tax_rate)
            tax_rate_3 = create(:tax_rate)
            get :index
            expect(assigns(:tax_rates)).to match_array([tax_rate_1, tax_rate_2, tax_rate_3])
        end
        it "renders the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "assigns a new tax_rate to @tax_rate" do
            get :new
            expect(assigns(:tax_rate)).to be_a_new(TaxRate)
        end
        it "renders the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        it "assigns the requested tax_rate to @tax_rate" do
            tax_rate = create(:tax_rate)
            get :edit , id: tax_rate
            expect(assigns(:tax_rate)).to eq tax_rate
        end
        it "renders the :edit template" do
            tax_rate = create(:tax_rate)
            get :edit, id: tax_rate
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new tax_rate in the database" do
                expect {
                    post :create, tax_rate: attributes_for(:tax_rate)
                }.to change(TaxRate, :count).by(1)
            end
            it "redirects to tax_rates#index"  do
                post :create, tax_rate: attributes_for(:tax_rate)
                expect(response).to redirect_to admin_tax_rates_url
            end
        end
        context "with invalid attributes" do
            it "does not save the new tax_rate in the database" do
                expect {
                    post :create, tax_rate: attributes_for(:invalid_tax_rate)
                }.to_not change(TaxRate, :count)
            end
            it "re-renders the :new template" do
                post :create, tax_rate: attributes_for(:invalid_tax_rate)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        before :each do
            @tax_rate = create(:tax_rate, name: 'tax_rate #1')
        end
        context "with valid attributes" do
            it "locates the requested @tax_rate" do
                put :update, id: @tax_rate, tax_rate: attributes_for(:tax_rate)
                expect(assigns(:tax_rate)).to eq(@tax_rate)
            end
            it "updates the tax_rate in the database" do
                put :update, id: @tax_rate, tax_rate: attributes_for(:tax_rate, name: 'tax_rate #2')
                @tax_rate.reload
                expect(@tax_rate.name).to eq('tax_rate #2')
            end
            it "redirects to the tax_rates#index" do
                put :update, id: @tax_rate, tax_rate: attributes_for(:tax_rate)
                expect(response).to redirect_to admin_tax_rates_url
            end
        end
        context "with invalid attributes" do 
            it "does not update the tax_rate" do
                put :update, id: @tax_rate, tax_rate: attributes_for(:invalid_tax_rate)
                @tax_rate.reload
                expect(@tax_rate.name).to eq('tax_rate #1')
            end
            it "re-renders the #edit template" do
                put :update, id: @tax_rate, tax_rate: attributes_for(:invalid_tax_rate)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        before :each do
            @tax_rate = create(:tax_rate)
        end
        it "deletes the tax_rate from the database"  do
            expect {
                delete :destroy, id: @tax_rate
            }.to change(TaxRate, :count).by(-1)
        end
        it "redirects to tax_rates#index" do
            delete :destroy, id: @tax_rate
            expect(response).to redirect_to admin_tax_rates_url
        end
    end
end