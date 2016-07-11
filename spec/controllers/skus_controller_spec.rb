require 'rails_helper'

describe SkusController do

    store_setting

    describe 'GET #update' do
        let(:product) { create(:product_sku) }

        it "should return a 200 status code" do
            xhr :get, :update, id: product.skus.first.id, product_id: product.id
            expect(response.status).to eq 200
        end
    end  
end