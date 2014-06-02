module CustomMacro

    # Creates the store settings record for use within the application
    #
    # @return [Object] current store settings
    def store_setting
        before(:each) do
            store_setting = create(:store_setting)
            allow_any_instance_of(Store).to receive(:settings).and_return(store_setting)
        end
    end

    # Logs an administrator user in for integration tests
    #
    def feature_login_admin
        before(:each) do
            admin = create(:admin)

            visit admin_root_path
            fill_in 'Email', with: admin.email
            fill_in 'Password', with: admin.password
            click_button 'Login'
        end
    end
end