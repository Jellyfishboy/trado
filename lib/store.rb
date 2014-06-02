module Store

    class << self

        # Retrieves the store settings from the admin user
        #
        # @return [Object] current store settings
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
        # @return [Decimal] tax rate value ready to be used in calculations
        def tax_rate
            Store::settings.tax_rate/100
        end

        # Detects whether an integer is positive
        #
        # @return [boolean]
        def positive? number
          return true if number > 0
        end

        # Sets the record's active field to false
        #
        # @return [Object] an inactive record
        def inactivate! record
            record.update_column(:active, false)
        end

        # Sets the record's active field to true
        #
        # @return [Object] an active record
        def activate! record
            record.update_column(:active, true)
        end
        
    end
end