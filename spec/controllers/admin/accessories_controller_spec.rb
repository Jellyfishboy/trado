require 'rails_helper'

describe Admin::AccessoriesController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:accessory_1) { create(:accessory, active: false) }
        let!(:accessory_2) { create(:accessory, active: true) }
        let!(:accessory_3) { create(:accessory, active: true) }

        it "should populate an array of active accessories" do
            get :index
            expect(assigns(:accessories)).to match_array([accessory_2, accessory_3])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "should assign a new accessory to @accessory" do
            get :new
            expect(assigns(:accessory)).to be_a_new(Accessory)
        end
        it "should render the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:accessory) { create(:accessory) }

        it "should assign the requested accessory to @accessory" do
            get :edit , id: accessory.id
            expect(assigns(:form_accessory)).to eq accessory
        end
        it "should render the :edit template" do
            get :edit, id: accessory.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "should save the new accessory in the database" do
                expect {
                    post :create, accessory: attributes_for(:accessory)
                }.to change(Accessory, :count).by(1)
            end
            it "should redirect to accessories#index"  do
                post :create, accessory: attributes_for(:accessory)
                expect(response).to redirect_to admin_accessories_url
            end
        end
        context "with invalid attributes" do
            it "should not save the new accessory in the database" do
                expect {
                    post :create, accessory: attributes_for(:invalid_accessory)
                }.to_not change(Accessory, :count)
            end
            it "should re-render the :new template" do
                post :create, accessory: attributes_for(:invalid_accessory)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PATCH #update' do
        let!(:accessory) { create(:accessory, name: 'accessory #1', active: true) }
        let(:new_accessory) { attributes_for(:accessory, active: true) }
        let(:order) { create(:order) }
        let(:order_item) { create(:order_item, order_id: order.id) }

        context "if the accessory has associated orders" do
            before(:each) do
                create(:order_item_accessory, accessory_id: accessory.id, order_item_id: order_item.id)
            end

            it "should set the accessory as inactive" do
                expect{
                    patch :update, id: accessory.id, accessory: new_accessory
                    accessory.reload
                }.to change{
                    accessory.active
                }.from(true).to(false)
            end

            it "should assign new accessory attributes to @accessory" do
                patch :update, id: accessory.id, accessory: new_accessory
                expect(assigns(:accessory).price).to eq new_accessory[:price]
                expect(assigns(:accessory).name).to eq new_accessory[:name]
            end

            it "should assign the inactive old accessory to @old_accessory" do
                patch :update, id: accessory.id, accessory: new_accessory
                expect(assigns(:old_accessory)).to eq accessory
            end
        end

        context "with valid attributes" do

            context "if the accessory has associated orders" do
                before(:each) do
                    create(:order_item_accessory, accessory_id: accessory.id, order_item_id: order_item.id)
                    create_list(:accessorisation, 3, accessory_id: accessory.id)
                    create_list(:cart_item_accessory, 4, accessory_id: accessory.id)
                end

                it "should save new tiereds to the database" do
                    expect{
                        patch :update, id: accessory.id, accessory: new_accessory
                    }.to change(Accessorisation, :count).by(3)
                end

                it "should delete any related cart item accessories from the database" do
                    expect{
                        patch :update, id: accessory.id, accessory: new_accessory
                    }.to change(CartItemAccessory, :count).by(-4)
                end

                it "should save a new accessory to the database" do
                    expect {
                        patch :update, id: accessory.id, accessory: new_accessory
                    }.to change(Accessory, :count).by(1)
                end
            end

            context "if the accessory has no associated orders" do

                it "should locate the requested @accessory" do
                    patch :update, id: accessory.id, accessory: attributes_for(:accessory, active: true)
                    expect(assigns(:accessory)).to eq(accessory)
                end

                it "should update the accessory in the database" do
                    patch :update, id: accessory.id, accessory: attributes_for(:accessory, name: 'accessory #2', active: true)
                    accessory.reload
                    expect(accessory.name).to eq('accessory #2')
                end
            end
            
            it " should redirect to the accessories#index" do
                patch :update, id: accessory.id, accessory: attributes_for(:accessory, active: true)
                expect(response).to redirect_to admin_accessories_url
            end
        end
        context "with invalid attributes" do 
            let(:new_accessory) { attributes_for(:invalid_accessory, active: true) }
            before(:each) do
                patch :update, id: accessory.id, accessory: new_accessory
            end

            it "should not update the accessory" do
                accessory.reload
                expect(accessory.name).to eq('accessory #1')
            end

            it "should assign the old_accessory to @form_accessory" do
                expect(assigns(:form_accessory)).to eq accessory
            end

            it "should set the old_accessory as active" do
                expect(accessory.active).to eq true
            end

            it "should assign the @form_accessory attributes with the current params accessory" do
                expect(assigns(:form_accessory).attributes["price"]). to eq new_accessory[:price]
                expect(assigns(:form_accessory).attributes["name"]).to eq new_accessory[:name]
            end

            it "should re-render the #edit template" do
                patch :update, id: accessory.id, accessory: attributes_for(:invalid_accessory, active: true)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:accessory) { create(:accessory) }
        let(:order) { create(:order) }
        let(:order_item) { create(:order_item, order_id: order.id) }
        let(:cart) { create(:cart) }
        let(:cart_item) { create(:cart_item, cart_id: cart.id) }

        it "should assign the requested accessory to @accessory" do
            delete :destroy, id: accessory.id
            expect(assigns(:accessory)).to eq accessory
        end

        context "if the accessory has associated orders" do
            before(:each) do
                create(:order_item_accessory, accessory_id: accessory.id, order_item_id: order_item.id)
            end

            it "should set the accessory as inactive" do
                expect{
                    delete :destroy, id: accessory.id
                    accessory.reload
                }.to change{
                    accessory.active
                }.from(true).to(false)
            end

            it "should not delete the accessory from the database" do
                expect{
                    delete :destroy, id: accessory.id
                }.to change(Accessory, :count).by(0)
            end
        end

        context "if the accessory has no associated orders" do

            it "should delete the accessory from the database"  do
                expect {
                    delete :destroy, id: accessory.id
                }.to change(Accessory, :count).by(-1)
            end
        end

        context "if the accessory has associated carts" do
            before(:each) do
                create(:cart_item_accessory, accessory_id: accessory.id, cart_item_id: cart_item.id)
            end

            it "should delete all associated cart item accessories from the database" do
                expect{
                    delete :destroy, id: accessory.id
                }.to change(CartItemAccessory, :count).by(-1)
            end
        end

        it "should redirect to accessories#index" do
            delete :destroy, id: accessory.id
            expect(response).to redirect_to admin_accessories_url
        end
    end
end