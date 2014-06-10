module Store

    class Price < AbstractController::Base
        include ActionView::Helpers::NumberHelper
        include AbstractController::Rendering
        include AbstractController::Helpers
        include AbstractController::Translation
        include AbstractController::AssetPaths
        include Rails.application.routes.url_helpers
        helper ApplicationHelper
        self.view_paths = "app/views"

        # Initial price logic which determines and executes tax calculations
        # You can override the tax calculation logic with a string in the second item of the parameter array
        # If the second item in the parameter array is a boolean and equals true, set the price DOM elements to price range
        #
        # @overload set(args)
        #   @param [Object] SKU record
        #   @param [String][Boolean] tax type | price range
        # @return [Decimal] price
        def initialize *args
            price = args[0]
            @price = Store::settings.tax_breakdown ? (args[1] == 'gross' ? taxify(price) : price) : (args[1] == 'net' ? price : taxify(price))
            @range = args[1] == true ? true : false
        end

        # Convert a price into an integer
        #
        # @return [integer] price
        def singularize
            (@price*100).round
        end

        # Rounds the decimal price down to two decimal places and adds the currency set in the store settings
        #
        # @return [String] price with currency
        def format
            number_to_currency(@price, :unit => Store::settings.currency, :precision => (@price.round == @price) ? 0 : 2)
        end

        # Render the markup when displaying the net and gross price if tax breakdown set to true
        # Else display the standard formatted price
        # This is globally accepted markup which predetermined styles
        #
        # @return [String] HTML for both net and gross prices
        def markup
            render(:partial => 'shared/price', :locals => { :net => format, :gross => Store::settings.tax_breakdown ? taxify(@price) : nil, :range => @range }, :format => [:html])
        end

        private

        # Calculate and add tax to a price
        #
        # @param price [Decimal]
        # @return [Decimal] price
        def taxify price
            (price*Store::tax_rate)+price
        end
    end
end