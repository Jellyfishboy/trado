require 'rails_helper'

describe SkusController do

    store_setting

    describe 'GET #update' do
        let(:sku) { create(:sku) }

        it "should render the SKU update partial" do
            xhr :get, :update, id: sku.id
            expect(response).to render_template(partial: "themes/#{Store::settings.theme.name}/products/skus/_update")
        end
    end  
end