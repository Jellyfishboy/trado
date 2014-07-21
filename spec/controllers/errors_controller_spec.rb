require 'rails_helper'

describe ErrorsController do

    store_setting

    describe 'GET #show' do

        context "if it is a 404 error" do

            it "should render the 404 template" do
                get :show, code: 404
                expect(response).to render_template('errors/404')
            end
        end

        context "if it is a 500 error" do

            it "should render the 500 template" do
                get :show, code: 500
                expect(response).to render_template('errors/500')
            end
        end

        context "if it is a 422 error" do

            it "should render the 422 template" do
                get :show, code: 422
                expect(response).to render_template('errors/422')
            end
        end
    end
end