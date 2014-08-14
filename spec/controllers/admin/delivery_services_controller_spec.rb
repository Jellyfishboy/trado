require 'rails_helper'

describe Admin::DeliveryServicesController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:delivery_service_1) { create(:delivery_service) }
        let!(:delivery_service_2) { create(:delivery_service, active: true) }
        let!(:delivery_service_3) { create(:delivery_service, active: true) }

        it "populates an array of active delivery_services" do
            get :index
            expect(assigns(:delivery_services)).to match_array([delivery_service_2, delivery_service_3])
        end
        it "renders the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "assigns a new delivery_service to @delivery_service" do
            get :new
            expect(assigns(:delivery_service)).to be_a_new(DeliveryService)
        end
        it "renders the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:delivery_service) { create(:delivery_service, active: true) }

        it "assigns the requested delivery service to @delivery_service" do
            get :edit , id: delivery_service.id
            expect(assigns(:form_delivery_service)).to eq delivery_service
        end
        it "renders the :edit template" do
            get :edit, id: delivery_service.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new delivery service in the database" do
                expect {
                    post :create, delivery_service: attributes_for(:delivery_service, active: true)
                }.to change(DeliveryService, :count).by(1)
            end
            it "redirects to delivery_service#index"  do
                post :create, delivery_service: attributes_for(:delivery_service, active: true)
                expect(response).to redirect_to admin_delivery_services_url
            end
        end
        context "with invalid attributes" do
            it "does not save the new delivery_service in the database" do
                expect {
                    post :create, delivery_service: attributes_for(:invalid_delivery_service, active: true)
                }.to_not change(DeliveryService, :count)
            end
            it "re-renders the :new template" do
                post :create, delivery_service: attributes_for(:invalid_delivery_service, active: true)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PATCH #update' do
        let!(:delivery_service) { create(:delivery_service, name: 'delivery_service #1', active: true) }
        let!(:delivery_service_price) { create(:delivery_service_price, active: true, delivery_service_id: delivery_service.id) }

        context "if the delivery_service has associated orders" do
            let(:new_delivery_service) { attributes_for(:delivery_service, active: true) }
            before(:each) do
                create(:order, delivery_service_price_id: delivery_service_price.id)
            end

            it "should set the delivery_service as inactive" do
                expect{
                    patch :update, id: delivery_service.id, delivery_service: new_delivery_service
                    delivery_service.reload
                }.to change{
                    delivery_service.active
                }.from(true).to(false)
            end

            it "should assign new delivery_service attributes to @delivery_service" do
                patch :update, id: delivery_service.id, delivery_service: new_delivery_service
                expect(assigns(:delivery_service).description).to eq new_delivery_service[:description]
                expect(assigns(:delivery_service).name).to eq new_delivery_service[:name]
            end

            it "should assign the inactive old delivery_service to @old_delivery_service" do
                patch :update, id: delivery_service.id, delivery_service: new_delivery_service
                expect(assigns(:old_delivery_service)).to eq delivery_service
            end
        end

        context "with valid attributes" do

            context "if the delivery_service has associated orders" do
                let(:new_delivery_service) { attributes_for(:delivery_service, active: true) }
                let!(:delivery_service_price) { create(:delivery_service_price, active: true, delivery_service_id: delivery_service.id) }

                before(:each) do
                    create(:order, delivery_service_price_id: delivery_service_price.id)
                    create_list(:destination, 4, delivery_service_id: delivery_service.id)
                end

                it "should save new destinations to the database" do
                    expect{
                        patch :update, id: delivery_service.id, delivery_service: new_delivery_service
                    }.to change(Destination, :count).by(4)
                end

                it "should save a new delivery_service to the database" do
                    expect {
                        patch :update, id: delivery_service.id, delivery_service: new_delivery_service
                    }.to change(DeliveryService, :count).by(1)
                end
            end

            context "if the delivery_service has no associated orders" do

                it "should locate the requested @delivery_service" do
                    patch :update, id: delivery_service.id, delivery_service: attributes_for(:delivery_service, active: true)
                    expect(assigns(:delivery_service)).to eq(delivery_service)
                end

                it "should update the delivery_service in the database" do
                    patch :update, id: delivery_service.id, delivery_service: attributes_for(:delivery_service, name: 'delivery_service #2', active: true)
                    delivery_service.reload
                    expect(delivery_service.name).to eq('delivery_service #2')
                end
            end
            
            it "redirects to the delivery_services#index" do
                patch :update, id: delivery_service.id, delivery_service: attributes_for(:delivery_service, active: true)
                expect(response).to redirect_to admin_delivery_services_url
            end
        end
        context "with invalid attributes" do 
            let(:new_delivery_service) { attributes_for(:invalid_delivery_service, active: true) }
            before(:each) do
                patch :update, id: delivery_service.id, delivery_service: new_delivery_service
            end

            it "should not update the delivery_service" do
                delivery_service.reload
                expect(delivery_service.name).to eq('delivery_service #1')
            end

            it "should assign the old_delivery_service to @form_delivery_service" do
                expect(assigns(:form_delivery_service)).to eq delivery_service
            end

            it "should set the old_delivery_service as active" do
                expect(delivery_service.active).to eq true
            end

            it "should assign the @form_delivery_service attributes with the current params delivery_service" do
                expect(assigns(:form_delivery_service).attributes["description"]). to eq new_delivery_service[:description]
                expect(assigns(:form_delivery_service).attributes["name"]).to eq new_delivery_service[:name]
            end

            it "should re-render the #edit template" do
                patch :update, id: delivery_service.id, delivery_service: attributes_for(:invalid_delivery_service, active: true)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:delivery_service) { create(:delivery_service, active: true) }
        let!(:delivery_service_price) { create(:delivery_service_price, active: true, delivery_service_id: delivery_service.id) }

        context "if there are no associated orders" do
        
            context "if there is more than one delivery_service in the database" do
                before :each do
                    create(:delivery_service, active: true)
                end

                it "should flash a success message" do
                    delete :destroy, id: delivery_service.id
                    expect(subject.request.flash[:success]).to_not be_nil
                end

                it "should delete the delivery_service from the database"  do
                    expect {
                        delete :destroy, id: delivery_service.id
                    }.to change(DeliveryService, :count).by(-1)
                end
            end

            context "if there is only one delivery_service in the database" do

                it "should flash a error message" do
                    delete :destroy, id: delivery_service.id
                    expect(subject.request.flash[:error]).to_not be_nil
                end

                it "should not delete the delivery_service from the database"  do
                    expect {
                        delete :destroy, id: delivery_service.id
                    }.to change(DeliveryService, :count).by(0)
                end
            end
        end

        context "if there are associated orders" do
            before(:each) do
                create(:order, delivery_service_id: delivery_service_price.id)
            end

            it "should flash a success message" do
                delete :destroy, id: delivery_service.id
                expect(subject.request.flash[:success]).to_not be_nil
            end

            it "should set the delivery_service as inactive" do
                expect{
                    delete :destroy, id: delivery_service.id
                    delivery_service.reload
                }.to change{
                    delivery_service.active
                }.from(true).to(false)
            end
        end

        it "should redirect to delivery_services#index" do
            delete :destroy, id: delivery_service.id
            expect(response).to redirect_to admin_delivery_services_url
        end
    end
end