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
end