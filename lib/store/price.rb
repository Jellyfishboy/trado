module Store

    class Price < AbstractController::Base
        attr_reader :price, :tax_type, :count
        include ActionView::Helpers::NumberHelper

        # Initial price logic which builds attributes to force behaviour, not data interaction
        #
        # @overload set(data)
        #   @param [Decimal] price
        #   @param [String] tax type
        #   @param [Integer] total record count
        # @return [Decimal] price
        def initialize data
            @price      = data[:price]
            @tax_type   = data[:tax_type]
            @count      = data[:count]
        end

        # Price logic
        # You can override the tax calculation logic with a string in the second item of the parameter array
        #
        # @return [Decimal] price
        def price
            Store::settings.tax_breakdown ? (tax_type == 'gross' ? taxify(@price) : @price) : (tax_type == 'net' ? @price : taxify(@price))
        end

        # If the store setting is set to show tax breakdown
        # Return a decimal value of the gross price
        #
        # @return [Decimal] price
        def gross_price
            Store::settings.tax_breakdown ? taxify(price) : nil
        end

        # If the record count for a product is more than one
        # Return true to display different HTML markup
        #
        # @return [boolean]
        def range_price
            count.nil? || count < 2 ? false : true
        end

        # Convert a price into an integer
        #
        # @return [integer] price
        def singularize
            (price * 100).round
        end

        # Returns a formatted single price.
        #
        # @return [String] formatted price
        def single
            format(price)
        end

        # Renders the DOM elements for a product with more than one SKU and thereby more than one price
        # If product has only one SKU, just show price as standard, however ignoring the Inc VAT value when store tax breakdown is turned on
        #
        # @return [String] HTML elements
        def range
            Renderer.render partial: 'shared/price/range', locals: { price: single, range: range_price, gross: format(gross_price) }, format: [:html]
        end

        # Render the markup when displaying the net and gross price if tax breakdown set to true
        # Else display the standard formatted price
        # This is globally accepted markup which predetermined styles
        #
        # @return [String] HTML for both net and gross prices
        def markup
            Renderer.render partial: 'shared/price/single', locals: { price: single, gross: format(gross_price) }, format: [:html]
        end

        private

        # Rounds the decimal price down to two decimal places and adds the currency set in the store settings, returning the value
        # Returns nil if the parameter is nil
        #
        # @param [Decimal] price
        # @return [String] price with currency
        def format price
            price.nil? ? nil : number_to_currency(price, unit: Store::settings.currency, precision: 2)
        end

        # Calculate and add tax to a price
        #
        # @param price [Decimal]
        # @return [Decimal] price
        def taxify price
            (price * Store::tax_rate) + price
        end
    end
end