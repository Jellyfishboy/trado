module CustomMacro

    # Creates the store settings record for use within the application
    #
    def store_setting
        before(:each) do
            store_setting = create(:attached_store_setting)
            allow_any_instance_of(Store).to receive(:settings).and_return(store_setting)
        end
    end

    # Logs an administrator user in for integration tests
    #
    def feature_login_admin
        before(:each) do
            admin = create(:attached_admin)

            visit admin_root_path
            fill_in('user_email', with: admin.email)
            fill_in('user_password', with: admin.password)
            click_button 'Login'
        end
    end

end