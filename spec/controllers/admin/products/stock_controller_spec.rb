require 'rails_helper'

describe Admin::Products::StockController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:sku_1) { create(:sku, active: true) }
        let!(:sku_2) { create(:sku, active: true) }

        it "should populate an array of all skus" do
            get :index
            expect(assigns(:skus)).to match_array([sku_1, sku_2])
        end
        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

    describe 'GET #show' do
        let(:sku) { create(:sku, active: true) }

        it "should assign the requested sku to @sku" do
            get :show, id: sku.id
            expect(assigns(:sku)).to eq sku
        end
        it "should render the :show template" do
            get :show, id: sku.id
            expect(response).to render_template :show
        end 

        it "should assign a new instance of StockAdjustment to @stock_adjustment" do
            get :show, id: sku.id
            expect(assigns(:stock_adjustment)).to be_a_new(StockAdjustment)
        end
    end
end