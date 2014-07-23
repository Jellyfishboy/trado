require 'rails_helper'

describe Admin::ProductsController do

    store_setting
    login_admin

    describe 'GET #index' do
        let!(:product_1) { create(:product, weighting: 2000, active: true) }
        let!(:product_2) { create(:product, weighting: 1000, active: true) }
        let!(:product_3) { create(:product, weighting: 3000, active: false) }
        let!(:category_1) { create(:category) }
        let!(:category_2) { create(:category) }

        it "should populate an array of all products" do
            get :index
            expect(assigns(:products)).to match_array([product_2, product_1])
        end

        # it "should populate an array of all categories" do
        #     get :index
        #     expect(assigns(:categories)).to match_array([category_1, category_2])
        # end

        it "should render the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end
end