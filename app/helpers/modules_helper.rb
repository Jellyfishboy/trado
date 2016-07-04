module ModulesHelper

    # Validates if the trado-paypal-module gem is active
    #
    # @return [Boolean]
    #
    def paypal_active?
        Object.const_defined?('TradoPaypalModule') ? true : false
    end

    # Validates if the trado-googlemerchant-module gem is active
    #
    # @return [Boolean]
    #
    def googlemerchant_active?
        Object.const_defined?('TradoGooglemerchantModule') ? true : false
    end
end