module ModulesHelper

    # Validates if the trado-paypal-module gem is active
    #
    # @return [Boolean]
    #
    def paypal_active?
        Object.const_defined?('TradoPaypalModule') ? true : false
    end
end