require 'rails_helper'

describe AccessoriesController do

    store_setting

    describe 'GET #update' do
        let(:accessory) { create(:accessory) }

        it "should render the accessory update partial" do
            xhr :get, :update, id: accessory.id
            expect(response).to render_template(partial: "themes/#{Store.settings.theme.name}/products/accessories/_update")
        end
    end  
end