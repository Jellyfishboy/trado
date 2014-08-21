module Store

    class Price < AbstractController::Base
        include ActionView::Helpers::NumberHelper

        # Initial price logic which determines and executes tax calculations
        # You can override the tax calculation logic with a string in the second item of the parameter array
        # If the second item in the parameter array is a boolean and equals true, set the price DOM elements to price range
        #
        # @overload set(args)
        #   @param [Decimal] price
        #   @param [String] tax type
        #   @param [Integer] total record count
        # @return [Decimal] price
        def initialize *args
            @count = parameterize(args, Integer)
            @range = @count.nil? ? nil : @count > 1 ? true : false
            @object = parameterize(args, ActiveRecord::Base)
            @override = parameterize(args, String)
            price = args[0]
            @price = Store::settings.tax_breakdown ? (@override == 'gross' ? taxify(price) : price) : (@override == 'net' ? price : taxify(price))
            @gross_price = Store::settings.tax_breakdown ? taxify(price) : nil
        end

        # Convert a price into an integer
        #
        # @return [integer] price
        def singularize
            (@price * 100).round
        end

        # Returns a formatted single price.
        #
        # @return [String] formatted price
        def single
            format(@price)
        end

        # Renders the DOM elements for a product with more than one SKU and thereby more than one price
        # If product has only one SKU, just show price as standard, however ignoring the Inc VAT value when store tax breakdown is turned on
        #
        # @return [String] HTML elements
        def range
            Renderer.render :partial => 'shared/price/range', :locals => { :price => single, :range => @range, :gross => format(@gross_price) }, :format => [:html]
        end

        # Render the markup when displaying the net and gross price if tax breakdown set to true
        # Else display the standard formatted price
        # This is globally accepted markup which predetermined styles
        #
        # @return [String] HTML for both net and gross prices
        def markup
            Renderer.render :partial => 'shared/price/single', :locals => { :price => single, :gross => format(@gross_price) }, :format => [:html]
        end

        private

        # Rounds the decimal price down to two decimal places and adds the currency set in the store settings, returning the value
        # Returns nil if the parameter is nil
        #
        # @param [Decimal] price
        # @return [String] price with currency
        def format price
            return price.nil? ? nil : number_to_currency(price, :unit => Store::settings.currency, :precision => 2)
        end

        # Clever method to filter out the string, integer and ActiveRecord::Base values from an array
        # Assigning them to their respective variables
        #
        # @return [Integer / ActiveRecord::Base / String]
        def parameterize *opts
            opts[0].each_with_index do |a, index|
                return nil if opts[0].count == 1
                next if index == 0
                return a if a.is_a?(opts[1])
            end
            return nil
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