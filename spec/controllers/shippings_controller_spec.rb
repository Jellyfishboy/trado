require 'rails_helper'

describe ShippingsController do

    store_setting

    describe 'GET #update' do
        let!(:cart) { create(:cart) }
        let(:tier_1) { create(:tier) }
        let(:tier_2) { create(:tier) }
        let(:tier_3) { create(:tier) }
        let(:zone) { create(:zone, name: 'EU') }
        let(:country) { create(:country, name: 'United Kingdom', zone_id: zone.id) }
        let(:shipping_1) { create(:shipping) }
        let(:shipping_2) { create(:shipping) }
        let(:shipping_3) { create(:shipping) }
        let!(:order) { create(:order, cart_id: cart.id, tiers: [tier_1.id,tier_2.id]) }
        
        before(:each) do
            create(:destination, zone_id: zone.id, shipping_id: shipping_1.id)
            create(:destination, zone_id: zone.id, shipping_id: shipping_2.id)
            create(:destination, zone_id: zone.id, shipping_id: shipping_3.id)
            create(:tiered, shipping_id: shipping_1.id, tier_id: tier_1.id)
            create(:tiered, shipping_id: shipping_2.id, tier_id: tier_2.id)
            create(:tiered, shipping_id: shipping_3.id, tier_id: tier_3.id)
            controller.stub(:current_cart).and_return(cart)
        end

        it "should assign a collection of available shippings to @shippings" do
            xhr :get, :update, { 'country_id' => country.name }
            expect(assigns(:shippings)).to match_array([shipping_1, shipping_2])
        end

        it "should render a shipping options partial" do
            xhr :get, :update, { 'country_id' => country.name }
            expect(response).to render_template(partial: 'orders/shippings/_fields')
        end
    end
end