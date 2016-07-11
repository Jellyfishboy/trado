require 'rails_helper'

describe SearchController, broken: true do

    store_setting

    describe 'GET #result' do
        let!(:product) { create(:product_sku_attachment, name: 'product #1', active: true) }

        it "should assign the query search results to @products" do
            get :results, query: 'product'
            expect(assigns(:products)).to match_array([product])
        end

        it "should render the :result template" do
            get :results, query: 'product'
            expect(response).to render_template(:results)
        end
    end

    describe 'GET #autocomplete' do
        let!(:product) { create(:product_sku_attachment, name: 'product #1', active: true) }

        it "should assign the query search results to @json_products" do
            xhr :get, :autocomplete, query: 'product'
            expect(assigns(:json_products).first[:value]).to eq product.name
            expect(assigns(:json_products).first[:product_slug]).to eq 'product-1'
            expect(assigns(:json_products).first[:category_name]).to eq product.category.name
        end
        
        it "should return a 200 status code" do
            xhr :get, :autocomplete, query: 'product'
            expect(response.status).to eq 200
        end
    end
end