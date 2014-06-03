require 'spec_helper'

feature 'Administration management' do

    store_setting
    feature_login_admin

    scenario 'should update the store settings' do

        visit admin_root_path
        find('.user-menu').click
        find('ul[role="menu"] li:nth-child(3) a').click
        expect(current_path).to eq admin_settings_path
    end
end