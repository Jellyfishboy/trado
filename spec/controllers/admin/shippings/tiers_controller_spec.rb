require 'rails_helper'

describe Admin::Shippings::TiersController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:tier_1) { create(:tier) }
        let!(:tier_2) { create(:tier) }

        it "should populate an array of all tiers" do
            get :index
            expect(assigns(:tiers)).to match_array([tier_1, tier_2])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "should assign a new Tier to @tier" do
            get :new
            expect(assigns(:tier)).to be_a_new(Tier)
        end
        it "should render the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:tier) { create(:tier) }

        it "should assign the requested tier to @tier" do
            get :edit , id: tier.id
            expect(assigns(:tier)).to eq tier
        end
        it "should render the :edit template" do
            get :edit, id: tier.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "should save the new tier in the database" do
                expect {
                    post :create, tier: attributes_for(:tier)
                }.to change(Tier, :count).by(1)
            end
            it "should redirect to tiers#index"  do
                post :create, tier: attributes_for(:tier)
                expect(response).to redirect_to admin_shippings_tiers_url
            end
        end
        context "with invalid attributes" do
            it "should not save the new tier in the database" do
                expect {
                    post :create, tier: attributes_for(:invalid_tier)
                }.to_not change(Tier, :count)
            end
            it "should re-render the :new template" do
                post :create, tier: attributes_for(:invalid_tier)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        let!(:tier) { create(:tier, length_start: '2.4') }

        context "with valid attributes" do
            it "should locate the requested @tier" do
                patch :update, id: tier.id, tier: attributes_for(:tier)
                expect(assigns(:tier)).to eq(tier)
            end
            it "should update the tier in the database" do
                patch :update, id: tier.id, tier: attributes_for(:tier, length_start: '8.34')
                tier.reload
                expect(tier.length_start).to eq(BigDecimal.new("8.34"))
            end
            it "should redirect to the tiers#index" do
                patch :update, id: tier.id, tier: attributes_for(:tier)
                expect(response).to redirect_to admin_shippings_tiers_url
            end
        end
        context "with invalid attributes" do 
            it "should not update the tier" do
                patch :update, id: tier.id, tier: attributes_for(:tier, length_start: nil)
                tier.reload
                expect(tier.length_start).to eq(BigDecimal.new("2.4"))
            end
            it "should re-render the #edit template" do
                patch :update, id: tier.id, tier: attributes_for(:invalid_tier)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:tier) { create(:tier) }
        
        context "if there is more than one tier in the database" do
            before :each do
                create(:tier)
            end

            it "should flash a success message" do
                delete :destroy, id: tier.id
                expect(subject.request.flash[:success]).to_not be_nil
            end

            it "should delete the tier from the database"  do
                expect {
                    delete :destroy, id: tier.id
                }.to change(Tier, :count).by(-1)
            end
        end

        context "if there is only one tier in the database" do

            it "should flash a error message" do
                delete :destroy, id: tier.id
                expect(subject.request.flash[:error]).to_not be_nil
            end

            it "should not delete the tier from the database"  do
                expect {
                    delete :destroy, id: tier.id
                }.to change(Tier, :count).by(0)
            end
        end
        it "should redirect to tiers#index" do
            delete :destroy, id: tier.id
            expect(response).to redirect_to admin_shippings_tiers_url
        end
    end

end