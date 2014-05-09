module StoreSettingMacro

    # Creates the store settings record for use within the application
    #
    # @return [object]
    def store_setting
        before(:each) do
            user = create(:user_settings)
            allow_any_instance_of(Store).to receive(:settings).and_return(user.store_setting)
        end
    end
end