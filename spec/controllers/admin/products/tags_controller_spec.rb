require 'rails_helper'

describe Admin::Products::TagsController do

    describe 'GET #index' do

        store_setting
        login_admin

        describe 'GET #index' do
            let!(:tags) { create_list(:tag, 3) }

            it "should assign all Tag records to @tags" do
                xhr :get, :index
                expect(assigns(:tags)).to eq tags.map(&:name)
            end

            it "should render a JSON object of tag names" do
                xhr :get, :index
                expect(response.body).to eq tags.map(&:name).to_json
            end
        end
    end
end