require 'rails_helper'

describe Admin::Products::StockAdjustmentsController do

    store_setting
    login_admin

    describe 'GET #new' do
        let(:sku_1) { create(:sku) }
        let(:sku_2) { create(:sku, active: true) }
        let(:sku_3) { create(:sku, active: true) }

        it "should populate an array off all active Skus" do
            get :new
            expect(assigns(:skus)).to match_array([sku_2, sku_3])
        end
        it "should render the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'POST #create' do
        let(:sku_1) { create(:sku, active: true) }
        let(:sku_2) { create(:sku, active: true) }
        let(:sku_3) { create(:sku) }

        it "should populate an array off all active Skus" do
            get :new
            expect(assigns(:skus)).to match_array([sku_1, sku_2])
        end

        it "should parse the stock_adjustments collection"

        context "if the request is HTML format" do

            it "should create a collection of StockAdjustment records"

            it "should redirect to products/stock#index"
        end

        context "if the request is JSON format" do

            context "if the collection of StockAdjustment records are valid" do

                it "should return a 200 status code"
            end

            context "if the collection of StockAdjustment records are invalid" do
                
                it "should return an error message"

                it "should return a 422 status code"
            end
        end
    end 
end