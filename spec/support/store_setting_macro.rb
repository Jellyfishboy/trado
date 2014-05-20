module StoreSettingMacro

    # Creates the store settings record for use within the application
    #
    # @return [object]
    def store_setting
        before(:each) do
            store_setting = create(:store_setting)
            allow_any_instance_of(Store).to receive(:settings).and_return(store_setting)
        end
    end
end