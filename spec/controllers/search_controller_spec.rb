require 'rails_helper'

describe SearchController do

    store_setting

    describe 'GET #result' do
        let!(:product) { create(:product, name: 'product #1', active: true) }

        it "should assign the query search results to @products" do
            get :results, query: 'product'
            expect(assigns(:products)).to match_array([product])
        end

        it "should render the :result template" do
            get :results, query: 'product'
            expect(response).to render_template(:result)
        end
    end
end