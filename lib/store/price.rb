module Store

    # simple price
    # tax price
    class Price
        include ActionView::Helpers::NumberHelper

        def initialize *args
            price = args[0]
            @price = Store::settings.tax_breakdown ? (args[1] == 'gross' ? (price*Store::tax_rate)+price : price) : (args[1] == 'net' ? price : (price*Store::tax_rate)+price)
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

        # Render the markup when displaying the net and gross price
        # This is globally accepted markup which predetermined styles
        #
        # @return [String] HTML for both net and gross prices
        def markup
            
        end
    end
end