require 'rails_helper'

describe Admin::DeliveryServicePricesController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:delivery_service_price_1) { create(:delivery_service_price) }
        let!(:delivery_service_price_2) { create(:delivery_service_price, active: true) }
        let!(:delivery_service_price_3) { create(:delivery_service_price, active: true) }

        it "populates an array of active delivery_service_prices" do
            get :index
            expect(assigns(:delivery_service_prices)).to match_array([delivery_service_price_2, delivery_service_price_3])
        end
        it "renders the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "assigns a new delivery_service_price to @delivery_service_price" do
            get :new
            expect(assigns(:delivery_service_price)).to be_a_new(DeliveryServicePrice)
        end
        it "renders the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:delivery_service_price) { create(:delivery_service_price, active: true) }

        it "assigns the requested delivery service to @delivery_service_price" do
            get :edit , id: delivery_service_price.id
            expect(assigns(:form_delivery_service_price)).to eq delivery_service_price
        end
        it "renders the :edit template" do
            get :edit, id: delivery_service_price.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new delivery service in the database" do
                expect {
                    post :create, delivery_service_price: attributes_for(:delivery_service_price, active: true)
                }.to change(DeliveryServicePrice, :count).by(1)
            end
            it "redirects to delivery_service_price#index"  do
                post :create, delivery_service_price: attributes_for(:delivery_service_price, active: true)
                expect(response).to redirect_to admin_delivery_service_prices_url
            end
        end
        context "with invalid attributes" do
            it "does not save the new delivery_service_price in the database" do
                expect {
                    post :create, delivery_service_price: attributes_for(:invalid_delivery_service_price, active: true)
                }.to_not change(Shipping, :count)
            end
            it "re-renders the :new template" do
                post :create, delivery_service_price: attributes_for(:invalid_delivery_service_price, active: true)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PATCH #update' do
        let!(:delivery_service_price) { create(:delivery_service_price, name: 'delivery_service_price #1', active: true) }

        context "if the delivery_service_price has associated orders" do
            let(:new_delivery_service_price) { attributes_for(:delivery_service_price, active: true) }
            before(:each) do
                create(:order, delivery_service_price_id: delivery_service_price.id)
            end

            it "should set the delivery_service_price as inactive" do
                expect{
                    patch :update, id: delivery_service_price.id, delivery_service_price: new_delivery_service_price
                    delivery_service_price.reload
                }.to change{
                    delivery_service_price.active
                }.from(true).to(false)
            end

            it "should assign new delivery_service_price attributes to @delivery_service_price" do
                patch :update, id: delivery_service_price.id, delivery_service_price: new_delivery_service_price
                expect(assigns(:delivery_service_price).description).to eq new_delivery_service_price[:description]
                expect(assigns(:delivery_service_price).name).to eq new_delivery_service_price[:name]
            end

            it "should assign the inactive old delivery_service_price to @old_delivery_service_price" do
                patch :update, id: delivery_service_price.id, delivery_service_price: new_delivery_service_price
                expect(assigns(:old_delivery_service_price)).to eq delivery_service_price
            end
        end

        context "with valid attributes" do

            context "if the delivery_service_price has associated orders" do
                let(:new_delivery_service_price) { attributes_for(:delivery_service_price, active: true) }
                before(:each) do
                    create(:order, delivery_service_price_id: delivery_service_price.id)
                    create_list(:tiered, 3, delivery_service_price_id: delivery_service_price.id)
                    create_list(:destination, 4, delivery_service_price_id: delivery_service_price.id)
                end

                it "should save new tiereds to the database" do
                    expect{
                        patch :update, id: delivery_service_price.id, delivery_service_price: new_delivery_service_price
                    }.to change(Tiered, :count).by(3)
                end

                it "should save new destinations to the database" do
                    expect{
                        patch :update, id: delivery_service_price.id, delivery_service_price: new_delivery_service_price
                    }.to change(Destination, :count).by(4)
                end

                it "should save a new delivery_service_price to the database" do
                    expect {
                        patch :update, id: delivery_service_price.id, delivery_service_price: new_delivery_service_price
                    }.to change(Shipping, :count).by(1)
                end
            end

            context "if the delivery_service_price has no associated orders" do

                it "should locate the requested @delivery_service_price" do
                    patch :update, id: delivery_service_price.id, delivery_service_price: attributes_for(:delivery_service_price, active: true)
                    expect(assigns(:delivery_service_price)).to eq(delivery_service_price)
                end

                it "should update the delivery_service_price in the database" do
                    patch :update, id: delivery_service_price.id, delivery_service_price: attributes_for(:delivery_service_price, name: 'delivery_service_price #2', active: true)
                    delivery_service_price.reload
                    expect(delivery_service_price.name).to eq('delivery_service_price #2')
                end
            end
            
            it "redirects to the delivery_service_prices#index" do
                patch :update, id: delivery_service_price.id, delivery_service_price: attributes_for(:delivery_service_price, active: true)
                expect(response).to redirect_to admin_delivery_service_prices_url
            end
        end
        context "with invalid attributes" do 
            let(:new_delivery_service_price) { attributes_for(:invalid_delivery_service_price, active: true) }
            before(:each) do
                patch :update, id: delivery_service_price.id, delivery_service_price: new_delivery_service_price
            end

            it "should not update the delivery_service_price" do
                delivery_service_price.reload
                expect(delivery_service_price.name).to eq('delivery_service_price #1')
            end

            it "should assign the old_delivery_service_price to @form_delivery_service_price" do
                expect(assigns(:form_delivery_service_price)).to eq delivery_service_price
            end

            it "should set the old_delivery_service_price as active" do
                expect(delivery_service_price.active).to eq true
            end

            it "should assign the @form_delivery_service_price attributes with the current params delivery_service_price" do
                expect(assigns(:form_delivery_service_price).attributes["description"]). to eq new_delivery_service_price[:description]
                expect(assigns(:form_delivery_service_price).attributes["name"]).to eq new_delivery_service_price[:name]
            end

            it "should re-render the #edit template" do
                patch :update, id: delivery_service_price.id, delivery_service_price: attributes_for(:invalid_delivery_service_price, active: true)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:delivery_service_price) { create(:delivery_service_price, active: true) }

        context "if there are no associated orders" do
        
            context "if there is more than one delivery_service_price in the database" do
                before :each do
                    create(:delivery_service_price, active: true)
                end

                it "should flash a success message" do
                    delete :destroy, id: delivery_service_price.id
                    expect(subject.request.flash[:success]).to_not be_nil
                end

                it "should delete the delivery_service_price from the database"  do
                    expect {
                        delete :destroy, id: delivery_service_price.id
                    }.to change(Shipping, :count).by(-1)
                end
            end

            context "if there is only one delivery_service_price in the database" do

                it "should flash a error message" do
                    delete :destroy, id: delivery_service_price.id
                    expect(subject.request.flash[:error]).to_not be_nil
                end

                it "should not delete the delivery_service_price from the database"  do
                    expect {
                        delete :destroy, id: delivery_service_price.id
                    }.to change(Shipping, :count).by(0)
                end
            end
        end

        context "if there are associated orders" do
            before(:each) do
                create(:order, delivery_service_price_id: delivery_service_price.id)
            end

            it "should flash a success message" do
                delete :destroy, id: delivery_service_price.id
                expect(subject.request.flash[:success]).to_not be_nil
            end

            it "should set the delivery_service_price as inactive" do
                expect{
                    delete :destroy, id: delivery_service_price.id
                    delivery_service_price.reload
                }.to change{
                    delivery_service_price.active
                }.from(true).to(false)
            end
        end

        it "should redirect to delivery_service_prices#index" do
            delete :destroy, id: delivery_service_price.id
            expect(response).to redirect_to admin_delivery_service_prices_url
        end
    end
end