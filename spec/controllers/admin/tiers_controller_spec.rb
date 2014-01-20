require 'spec_helper'
require 'bigdecimal'

describe Admin::TiersController do

    login_admin

    describe 'GET #index' do
            it "populates an array of all tiers" do
                tier_1 = create(:tier)
                tier_2 = create(:tier)
                get :index
                expect(assigns(:tiers)).to match_array([tier_1, tier_2])
            end
            it "renders the :index template" do
                get :index
                expect(response).to render_template :index
            end
    end

    describe 'GET #new' do
        it "assigns a new Tier to @tier" do
            get :new
            expect(assigns(:tier)).to be_a_new(Tier)
        end
        it "renders the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        it "assigns the requested tier to @tier" do
            tier = create(:tier)
            get :edit , id: tier
            expect(assigns(:tier)).to eq tier
        end
        it "renders the :edit template" do
            tier = create(:tier)
            get :edit, id: tier
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new tier in the database" do
                expect {
                    post :create, tier: attributes_for(:tier)
                }.to change(Tier, :count).by(1)
            end
            it "redirects to tiers#index"  do
                post :create, tier: attributes_for(:tier)
                expect(response).to redirect_to admin_tiers_url
            end
        end
        context "with invalid attributes" do
            it "does not save the new tier in the database" do
                expect {
                    post :create, tier: attributes_for(:invalid_tier)
                }.to_not change(Tier, :count)
            end
            it "re-renders the :new template" do
                post :create, tier: attributes_for(:invalid_tier)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        before :each do
            @tier = create(:tier, length_start: 1.1, length_end: 2.1)
        end
        context "with valid attributes" do
            it "locates the requested @tier" do
                put :update, id: @tier, tier: attributes_for(:tier)
                expect(assigns(:tier)).to eq(@tier)
            end
            it "updates the tier in the database" do
                put :update, id: @tier, tier: attributes_for(:tier, length_start: 3.1, length_end: 4.1)
                @tier.reload
                expect(@tier.length_start).to eq(3.1)
                expect(@tier.length_end).to eq(4.1)
            end
            it "redirects to the tiers#index" do
                put :update, id: @tier, tier: attributes_for(:tier)
                expect(response).to redirect_to admin_tiers_url
            end
        end
        context "with invalid attributes" do 
            it "does not update the tier" do
                put :update, id: @tier, tier: attributes_for(:tier, length_start: nil, length_end: 4.1)
                @tier.reload
                expect(@tier.length_start).to eq(BigDecimal.new("1.1"))
                expect(@tier.length_end).to eq(BigDecimal.new("2.1"))
            end
            it "re-renders the #edit template" do
                put :update, id: @tier, tier: attributes_for(:invalid_tier)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        before :each do
            @tier = create(:tier)
        end
        it "deletes the tier from the database"  do
            expect {
                delete :destroy, id: @tier
            }.to change(Tier, :count).by(-1)
        end
        it "redirects to tiers#index" do
            delete :destroy, id: @tier
            expect(response).to redirect_to admin_tiers_url
        end
    end

end