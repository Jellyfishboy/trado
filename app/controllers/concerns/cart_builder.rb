module CartBuilder
    extend ActiveSupport::Concern

    included do

        def set_order
            @order = current_cart.order.nil? ? Order.new : current_cart.order
        end

        def set_browser_data
            @order.browser = "#{browser.device.name} / #{browser.platform.name} / #{browser.name} / #{browser.version}" if browser.known?
        end

        def set_cart_totals
            @cart_totals = current_cart.calculate(Store.tax_rate)
        end

        def set_cart_session
            @cart_session = {
                country: (@order.nil? || @order.delivery_address.nil?) ? current_cart.country : @order.delivery_address.country,
                delivery_id: (@order.nil? || @order.new_record?) ? current_cart.delivery_id : @order.delivery_id
            }
        end

        def set_delivery_services
            @delivery_services = @cart_session[:country].nil? ? nil : DeliveryServicePrice.find_collection(current_cart.delivery_service_ids, @cart_session[:country])
        end
    end
end