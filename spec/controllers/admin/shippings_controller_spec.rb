require 'rails_helper'

describe Admin::ShippingsController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:shipping_1) { create(:shipping, active: false) }
        let!(:shipping_2) { create(:shipping, active: true) }
        let!(:shipping_3) { create(:shipping, active: true) }

        it "populates an array of active shippings" do
            get :index
            expect(assigns(:shippings)).to match_array([shipping_2, shipping_3])
        end
        it "renders the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #new' do
        it "assigns a new shipping to @shipping" do
            get :new
            expect(assigns(:shipping)).to be_a_new(Shipping)
        end
        it "renders the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:shipping) { create(:shipping, active: true) }

        it "assigns the requested shipping to @shipping" do
            get :edit , id: shipping.id
            expect(assigns(:form_shipping)).to eq shipping
        end
        it "renders the :edit template" do
            get :edit, id: shipping.id
            expect(response).to render_template :edit
        end
    end
    
    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new shipping in the database" do
                expect {
                    post :create, shipping: attributes_for(:shipping, active: true)
                }.to change(Shipping, :count).by(1)
            end
            it "redirects to shippings#index"  do
                post :create, shipping: attributes_for(:shipping, active: true)
                expect(response).to redirect_to admin_shippings_url
            end
        end
        context "with invalid attributes" do
            it "does not save the new shipping in the database" do
                expect {
                    post :create, shipping: attributes_for(:invalid_shipping, active: true)
                }.to_not change(Shipping, :count)
            end
            it "re-renders the :new template" do
                post :create, shipping: attributes_for(:invalid_shipping, active: true)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PATCH #update' do
        let!(:shipping) { create(:shipping, name: 'shipping #1', active: true) }

        context "with valid attributes" do
            it "locates the requested @shipping" do
                patch :update, id: shipping.id, shipping: attributes_for(:shipping, active: true)
                expect(assigns(:shipping)).to eq(shipping)
            end
            it "updates the shipping in the database" do
                patch :update, id: shipping.id, shipping: attributes_for(:shipping, name: 'shipping #2', active: true)
                shipping.reload
                expect(shipping.name).to eq('shipping #2')
            end
            it "redirects to the shippings#index" do
                patch :update, id: shipping.id, shipping: attributes_for(:shipping, active: true)
                expect(response).to redirect_to admin_shippings_url
            end
        end
        context "with invalid attributes" do 
            it "does not update the shipping" do
                patch :update, id: shipping.id, shipping: attributes_for(:invalid_shipping, active: true)
                shipping.reload
                expect(shipping.name).to eq('shipping #1')
            end
            it "re-renders the #edit template" do
                patch :update, id: shipping.id, shipping: attributes_for(:invalid_shipping, active: true)
                expect(response).to render_template :edit
            end
        end 
    end
    
    describe 'DELETE #destroy' do
        let!(:shipping) { create(:shipping, active: true) }

        context "if there are no associated orders" do
        
            context "if there is more than one shipping in the database" do
                before :each do
                    create(:shipping, active: true)
                end

                it "should flash a success message" do
                    delete :destroy, id: shipping.id
                    expect(subject.request.flash[:success]).to_not be_nil
                end

                it "should delete the shipping from the database"  do
                    expect {
                        delete :destroy, id: shipping.id
                    }.to change(Shipping, :count).by(-1)
                end
            end

            context "if there is only one shipping in the database" do

                it "should flash a error message" do
                    delete :destroy, id: shipping.id
                    expect(subject.request.flash[:error]).to_not be_nil
                end

                it "should not delete the shipping from the database"  do
                    expect {
                        delete :destroy, id: shipping.id
                    }.to change(Shipping, :count).by(0)
                end
            end
        end

        context "if there are associated orders" do
            before(:each) do
                create(:order, shipping_id: shipping.id)
            end

            it "should flash a success message" do
                delete :destroy, id: shipping.id
                expect(subject.request.flash[:success]).to_not be_nil
            end

            it "should set the shipping as inactive" do
                expect{
                    delete :destroy, id: shipping.id
                    shipping.reload
                }.to change{
                    shipping.active
                }.from(true).to(false)
            end
        end

        it "should redirect to shippings#index" do
            delete :destroy, id: shipping.id
            expect(response).to redirect_to admin_shippings_url
        end
    end
end