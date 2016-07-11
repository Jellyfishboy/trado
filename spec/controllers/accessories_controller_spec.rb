require 'rails_helper'

describe AccessoriesController do

    store_setting

    describe 'GET #update' do
        let(:product) { create(:product_sku) }
        let(:accessory) { create(:accessory) }
        before(:each) do
            create(:accessorisation, product: product, accessory: accessory)
        end
        it "should return a 200 status code" do
            xhr :get, :update, product_id: product.id, sku_id: product.skus.first.id
            expect(response.status).to eq 200
        end
    end  
end