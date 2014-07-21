require 'rails_helper'

describe ShippingsController do

    store_setting

    describe 'GET #update' do

        it "should render a shipping options partial" do
            xhr :get, :update
            expect(response).to render_template(partial: 'orders/shippings/_fields')
        end
    end
end