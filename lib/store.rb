module Store

    class << self

        # Retrieves the store settings from the admin user
        #
        # @return [Store::settings]
        def settings
          @@store_settings ||= StoreSetting.first
        end

        # Clears the store_settings class variable so they can be taken
        # from the database when next accessed
        #
        # @return [nil]
        def reset_settings
          @@store_settings = nil
        end

        # Returns a divided value of the tax rate in the Store settings, ready for use in calculations
        #
        # @returns [decimal]
        def tax_rate
            Store::settings.tax_rate/100
        end

        # Detects whether an integer is positive
        #
        # @return [boolean]
        def positive? number
          return true if number > 0
        end
        
    end
end