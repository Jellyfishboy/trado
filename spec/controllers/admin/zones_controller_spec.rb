require 'rails_helper'

describe Admin::ZonesController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:zone_1) { create(:zone) }
        let!(:zone_2) { create(:zone) }

        it "should populate an array of all zones" do
            get :index
            expect(assigns(:zones)).to match_array([zone_1, zone_2])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "should assign a new Zone to @zone" do
            get :new
            expect(assigns(:zone)).to be_a_new(Zone)
        end
        it "should render the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:zone) { create(:zone) }

        it "should assign the requested zone to @zone" do
            get :edit , id: zone.id
            expect(assigns(:zone)).to eq zone
        end
        it "should render the :edit template" do
            get :edit, id: zone.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "should save the new zone in the database" do
                expect {
                    post :create, zone: attributes_for(:zone)
                }.to change(Zone, :count).by(1)
            end
            it "should redirect to zones#index"  do
                post :create, zone: attributes_for(:zone)
                expect(response).to redirect_to admin_zones_url
            end
        end
        context "with invalid attributes" do
            it "should not save the new zone in the database" do
                expect {
                    post :create, zone: attributes_for(:invalid_zone)
                }.to_not change(Zone, :count)
            end
            it "should re-render the :new template" do
                post :create, zone: attributes_for(:invalid_zone)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        let!(:zone) { create(:zone, name: 'Zone #1') }

        context "with valid attributes" do
            it "should locate the requested @zone" do
                patch :update, id: zone.id, zone: attributes_for(:zone)
                expect(assigns(:zone)).to eq(zone)
            end
            it "should update the zone in the database" do
                patch :update, id: zone.id, zone: attributes_for(:zone, name: 'Zone #2')
                zone.reload
                expect(zone.name).to eq('Zone #2')
            end
            it "should redirect to the zones#index" do
                patch :update, id: zone.id, zone: attributes_for(:zone)
                expect(response).to redirect_to admin_zones_url
            end
        end
        context "with invalid attributes" do 
            it "should not update the zone" do
                patch :update, id: zone.id, zone: attributes_for(:invalid_zone)
                zone.reload
                expect(zone.name).to eq('Zone #1')
            end
            it "should re-render the #edit template" do
                patch :update, id: zone.id, zone: attributes_for(:invalid_zone)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:zone) { create(:zone) }
        
        context "if there is more than one zone in the database" do
            before :each do
                create(:zone)
            end

            it "should flash a success message" do
                delete :destroy, id: zone.id
                expect(subject.request.flash[:success]).to_not be_nil
            end

            it "should delete the zone from the database"  do
                expect {
                    delete :destroy, id: zone.id
                }.to change(Zone, :count).by(-1)
            end
        end

        context "if there is only one zone in the database" do

            it "should flash a error message" do
                delete :destroy, id: zone.id
                expect(subject.request.flash[:error]).to_not be_nil
            end

            it "should not delete the zone from the database"  do
                expect {
                    delete :destroy, id: zone.id
                }.to change(Zone, :count).by(0)
            end
        end
        it "should redirect to zones#index" do
            delete :destroy, id: zone.id
            expect(response).to redirect_to admin_zones_url
        end
    end
end