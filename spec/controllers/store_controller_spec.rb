require 'rails_helper'

describe StoreController do

    store_setting

    describe 'GET #index' do
        
        it "should render the :home template" do
            get :home
            expect(response).to render_template :home
        end
    end
end