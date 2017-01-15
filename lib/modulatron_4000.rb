module Modulatron4000

    class << self


        # Validates if the trado-paypal-module gem is active
        # https://github.com/Jellyfishboy/trado-paypal-module
        #
        # @return [Boolean]
        #
        def paypal?
            Object.const_defined?('TradoPaypalModule') ? true : false
        end

        # Validates if the trado-googlemerchant-module gem is active
        # https://github.com/Jellyfishboy/trado-googlemerchant-module
        #
        # @return [Boolean]
        #
        def googlemerchant?
            Object.const_defined?('TradoGooglemerchantModule') ? true : false
        end

        # Validates if the trado-stripe-module gem is active
        #
        # @return [Boolean]
        #
        def stripe?
            Object.const_defined?('TradoStripeModule') ? true : false
        end

        # Validates if the trado-mailchimp-module gem is active
        # https://github.com/Jellyfishboy/trado-mailchimp-module
        #
        # @return [Boolean]
        #
        def mailchimp?
            Object.const_defined?('TradoMailchimpModule') ? true : false
        end

        # Validates if the trado-pdf-invoice-module gem is active
        # https://github.com/Jellyfishboy/trado-pdf-invoice-module
        #
        # @return [Boolean]
        #
        def pdf_invoice?
            Object.const_defined?('TradoPdfInvoiceModule') ? true : false
        end
    end
end