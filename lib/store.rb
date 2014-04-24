module Store

    class << self

        # Retrieves the store settings from the admin user
        #
        # @return [Store::settings]
        def settings
          @@store_settings ||= User.where(:role => 'admin').first.store_setting
        end

        # Clears the store_settings class variable so they can be taken
        # from the database when next accessed
        #
        # @return [nil]
        def reset_settings
          @@store_settings = nil
        end

        # Sets the tax_rate for the entire store
        #
        # @return [Store::tax_rate]
        def tax_rate
          @@current_country ||= Country.where('available = ?', true).first
          if @@current_country
            @@current_country.tax ? @@current_country.tax.rate/100 : 0.2
          else
            0.2
          end
        end

        # Clears the current_country class variable so the new country can be taken
        # from the database when next accessed
        #
        # @return [nil]
        def reset_tax_rate
          @@current_country = nil
        end

        # Detects whether an integer is positive
        #
        # @return [boolean]
        def positive? number
          return true if number > 0
        end
        
    end
end