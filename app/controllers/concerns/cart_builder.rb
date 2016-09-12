module CartBuilder
    extend ActiveSupport::Concern

    included do

        def set_order
            @order = current_cart.order.nil? ? Order.new : current_cart.order
        end

        def set_browser_data
            @order.browser = [browser.device.name,browser.platform.name,browser.name,browser.version].join(' / ') if browser.known?
        end

        def set_cart_totals
            @cart_totals = current_cart.calculate(Store.tax_rate)
        end

        def set_grouped_countries
            @grouped_countries = [Country.popular.map{ |country| [country.name, country.id] }, Country.all.order('name ASC').map{ |country| [country.name, country.id] }] 
        end
    end
end