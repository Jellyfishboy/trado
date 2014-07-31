require 'rails_helper'

describe StoreController do

    store_setting

    describe 'GET #index' do
        
        it "should render the :home template" do
            get :home
            expect(response).to render_template :home
        end
    end

    describe 'GET #about' do

        it "should render the :about template" do
            get :about
            expect(response).to render_template :about
        end
    end

    describe 'GET #contact' do

        it "should render the :contact template" do
            get :contact
            expect(response).to render_template :contact
        end
    end
end