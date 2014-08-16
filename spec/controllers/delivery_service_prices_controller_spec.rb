require 'rails_helper'

describe DeliveryServicePricesController do

    store_setting

    describe 'GET #update' do
        let!(:cart) { create(:cart) }
        let(:zone_1) { create(:zone, name: 'EU') }
        let(:country_1) { create(:country, name: 'United Kingdom') }
        let(:zone_2) { create(:zone, name: 'Asia') }
        let(:country_2) { create(:country, name: 'China') }
        let(:delivery_service_1) { create(:delivery_service, active: true) }
        let!(:delivery_service_price_1) { create(:delivery_service_price, active: true, delivery_service_id: delivery_service_1.id) }
        let!(:delivery_service_price_2) { create(:delivery_service_price, active: true, delivery_service_id: delivery_service_1.id) }
        let(:delivery_service_2) { create(:delivery_service, active: true) }
        let!(:delivery_service_price_3) { create(:delivery_service_price, active: true, delivery_service_id: delivery_service_2.id) }
        let!(:order) { create(:order, cart_id: cart.id, delivery_service_prices: [delivery_service_price_1.id,delivery_service_price_2.id,delivery_service_price_3.id]) }
        
        before(:each) do
            create(:zonification, zone_id: zone_1.id, country_id: country_1.id)
            create(:zonification, zone_id: zone_2.id, country_id: country_2.id)
            create(:destination, zone_id: zone_1.id, delivery_service_id: delivery_service_1.id)
            create(:destination, zone_id: zone_2.id, delivery_service_id: delivery_service_2.id)
            controller.stub(:current_cart).and_return(cart)
        end

        it "should assign a collection of available delivery service prices to @delivery_service_prices" do
            xhr :get, :update, { 'country_id' => country_1.name }
            expect(assigns(:delivery_service_prices)).to match_array([delivery_service_price_1, delivery_service_price_2])
        end

        it "should render a delivery service prices partial" do
            xhr :get, :update, { 'country_id' => country_1.name }
            expect(response).to render_template(partial: 'orders/delivery_service_prices/_fields')
        end
    end
end