require 'spec_helper'

describe CategoriesController do

    describe 'GET#show' do
        it "assigns the requested category to @category" do
            category = create(:category)
            get :show, id: category
            expect(assigns(:category)).to eq category
        end
        it "renders the :show template" do
            category = create(:category)
            get :show, id: category 
            expect(response).to render_template :show
        end 
    end

end