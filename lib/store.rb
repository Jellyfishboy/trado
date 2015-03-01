require 'store/google_api'
require 'store/price'
require 'store/pay_provider'
require 'store/theme_tools'

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
        # @param number [Integer]
        # @return [boolean]
        def positive? number
          return number > 0 ? true : false
        end

        # Sets the record's active field to false
        #
        # @param record [Object]
        def inactivate! record
            record.update_column(:active, false)
        end

        # Sets the record's active field to true
        #
        # @param record [Object]
        def activate! record
            record.update_column(:active, true)
        end

        # Sets the collection of records' active field to false
        #
        # @param record [Array]
        def inactivate_all! records
            records.update_all(active: false)
        end    

        # Parses the object's parent class name into a camelcase string
        #
        # @param object [Object]
        # @return [String] class name to string
        def class_name object
            return object.class.to_s.split(/(?=[A-Z])/).join(' ')
        end

        # Checks if the class record count is less than 2
        # If its less than two return a failed string message
        # If its more then destroy the passed in object and return success string message
        #
        # @param object [Object]
        # @param count [Integer]
        # @return [Array] flash status symbol and message
        def last_record object, count
            if count < 2
                return [:error, "Failed to delete #{Store::class_name(object).downcase} - you must have at least one."]
            else
                object.destroy
                return [:success, "#{Store::class_name(object).capitalize} was successfully deleted."]
            end
        end

        # Parameterizes strings and replaces underscores with hyphens
        #
        # @param slug [String]
        #
        # @return [String] url friendly slug
        def parameterize_slug slug
            slug = slug.parameterize.split('_').join('-')
            return slug
        end

        # Active archiving logic when deleting a record
        # Destroy any related cart items
        # If the record has related orders, it should archive the record and set it's active attribute to true
        #
        # @param class_name [Class]
        # @param symbol [Symbol]
        # @param record [Object]
        #
        def active_archive class_name, symbol, record
            class_name.where(symbol => record.id).destroy_all unless record.carts.empty?
            record.orders.empty? ? record.destroy : Store::inactivate!(record)
        end

        # Build the tracking url from the tracking_url and consignment parameters
        #
        # @param tracking_url [String]
        # @param consignment_number [String]
        #
        # @return [String] complete tracking url
        def tracking_url url, consignment_number
            url.sub('{{consignment_number}}', consignment_number)
        end
    end
end