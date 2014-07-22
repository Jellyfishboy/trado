require 'rails_helper' 

describe Admin::AdminController do

    store_setting
    login_admin

    describe 'GET #settings' do

        it "should assign the current store settings to @settings" do
            get :settings
            expect(assigns(:settings)).to eq Store::settings
        end

        it "should render the :settings template" do
            get :settings
            expect(response).to render_template(:settings)
        end
    end

    describe 'PATCH #update' do
        let(:store_setting) { create(:store_setting, tax_rate: '1.22') }
        before(:each) do
            Store::reset_settings
            StoreSetting.destroy_all
            store_setting
            Store::settings
        end

        it "should assign the current store settings to @settings" do
            patch :update, store_setting: attributes_for(:store_setting)
            expect(assigns(:settings)).to eq Store::settings
        end

        context "with valid attributes" do

            it "should update the current store settings" do
                patch :update, store_setting: attributes_for(:store_setting, currency: '$', tax_rate: 15.6) 
                expect(Store::settings.currency).to eq '$'
                expect(Store::settings.tax_rate).to eq BigDecimal.new("15.6")
            end

            it "should redirect to the admin root" do
                patch :update, store_setting: attributes_for(:store_setting)
                expect(response).to redirect_to(admin_root_url)
            end
        end

        context "with invalid attributes" do

            it "should not update the current store settings" do
                patch :update, store_setting: attributes_for(:store_setting, name: nil)
                expect(store_setting.tax_rate).to eq BigDecimal.new("1.22")
            end

            it "should re-render the settings template" do
                patch :update, store_setting: attributes_for(:store_setting, name: nil)
                expect(response).to render_template(:settings)
            end
        end
    end
end