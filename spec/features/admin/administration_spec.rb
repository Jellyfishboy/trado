require 'rails_helper'

feature 'Administration management' do

    store_setting
    feature_login_admin
    given(:store_setting) { create(:store_setting) }

    scenario 'should edit the store settings' do
        Store::reset_settings
        StoreSetting.destroy_all
        store_setting
        Store::settings

        visit admin_root_path
        find('a[data-original-title="Settings"]').click
        expect(current_path).to eq admin_settings_path

        fill_in('store_setting_name', with: 'Test store name')
        fill_in('store_setting_tax_name', with: 'Tax')
        find('#store_setting_tax_breakdown_true').set(true)
        click_button 'Submit'
        expect(current_path).to eq admin_root_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Store settings were successfully updated.'
        end
        Store::reset_settings
        expect(Store::settings.name).to eq 'Test store name'
        expect(Store::settings.tax_name).to eq 'Tax'
        expect(Store::settings.tax_breakdown).to eq true
    end

    scenario 'should log out successfully' do

        visit admin_root_path
        find('.user-menu').click
        find('ul[role="menu"] li:last-child a').click
        expect(current_path).to eq new_user_session_path
    end

    scenario 'should edit the administrator profile' do

        visit admin_root_path
        find('.user-menu').click
        find('ul[role="menu"] li:first-child a').click
        expect(current_path).to eq admin_profile_path

        fill_in('user_first_name', with: 'Tom')
        fill_in('user_last_name', with: 'Dallimore')
        click_button 'Submit'
        expect(current_path).to eq admin_root_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Profile was successfully updated.'
        end
        admin = User.joins(:roles).where(:roles => { :name => 'admin' }).first
        expect(admin.first_name).to eq 'Tom'
        expect(admin.last_name).to eq 'Dallimore'
    end
end