require 'spec_helper'

describe StoreController do

    describe 'GET #index' do
        it "populates an array of all products" do
            product_1 = create(:product)
            product_2 = create(:product)
            get :index
            expect(assigns(:products)).to match_array([product_1, product_2])
        end
        it "renders the :index template" do
            get :index
            expect(response).to render_template :index
        end
    end

end