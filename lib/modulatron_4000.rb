module Modulatron4000

    class << self


        # Validates if the trado-paypal-module gem is active
        #
        # @return [Boolean]
        #
        def paypal?
            Object.const_defined?('TradoPaypalModule') ? true : false
        end

        # Validates if the trado-googlemerchant-module gem is active
        #
        # @return [Boolean]
        #
        def googlemerchant?
            Object.const_defined?('TradoGooglemerchantModule') ? true : false
        end
    end
end