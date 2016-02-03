module Payatron4000

    class Paypal

        # Builds the a PayPal purchase request from the order data
        # If successful, redirect to PayPal for the user to login
        # If unsuccessful, redirect to failed order page
        #
        # @param cart [Object]
        # @param order [Object]
        # @param ip_address [String]
        # @return [String] redirect url
        def self.build cart, order, ip_address
          response = EXPRESS_GATEWAY.setup_purchase(
                        Store::Price.new(price: order.gross_amount, tax_type: 'net').singularize, 
                        Payatron4000::Paypal.express_setup_options( 
                          order,
                          cart,
                          ip_address, 
                          Rails.application.routes.url_helpers.confirm_order_url(order), 
                          Rails.application.routes.url_helpers.mycart_carts_url
                        )
          )
          if response.success?
            return EXPRESS_GATEWAY.redirect_url_for(response.token)
          else
            Payatron4000::Paypal.failed(response, order)
            Payatron4000.decommission_order(order)
            return Rails.application.routes.url_helpers.failed_order_url(order)
          end
        end

        # Creates the payment information object for PayPal to parse in the login
        #
        # @param order [Object]
        # @param cart [Object]
        # @param ip_address [String]
        # @param return_url [String]
        # @param cancel_url [String]
        # @return [Object] order data from the store for PayPal
        def self.express_setup_options order, cart, ip_address, return_url, cancel_url
            {
              :subtotal          => Store::Price.new(price: order.net_amount, tax_type: 'net').singularize,
              :shipping          => Store::Price.new(price: order.delivery.price, tax_type: 'net').singularize,
              :tax               => Store::Price.new(price: order.tax_amount, tax_type: 'net').singularize,
              :handling          => 0,
              :order_id          => order.id,
              :items             => Payatron4000::Paypal.express_items(cart),
              :ip                => ip_address,
              :return_url        => return_url,
              :cancel_return_url => cancel_url,
              :currency          => Store.settings.paypal_currency_code,
            }
        end

        # Creates the payment information object for PayPal to parse in the confirmation step and complete the purchase
        #
        # @param order [Object]
        # @return [Object] current customer order
        def self.express_purchase_options order
            {
              :subtotal          => Store::Price.new(price: order.net_amount, tax_type: 'net').singularize,
              :shipping          => Store::Price.new(price: order.delivery.price, tax_type: 'net').singularize,
              :tax               => Store::Price.new(price: order.tax_amount, tax_type: 'net').singularize,
              :handling          => 0,
              :token             => order.express_token,
              :payer_id          => order.express_payer_id,
              :currency          => Store.settings.paypal_currency_code,
            }
        end

        # Creates an aray of items which represent cart_items
        # This is passed into the express_setup_options method
        #
        # @return [Array] list of cart items for PayPal
        def self.express_items cart
            cart.cart_items.collect do |item|
                {
                  :name               => item.sku.product.name,
                  :description        => item.sku.variants.map{|v| v.name.titleize}.join(' / '),
                  :amount             => Store::Price.new(price: item.price, tax_type: 'net').singularize, 
                  :quantity           => item.quantity 
                }
            end
        end

        # Assign PayPal token to order after user logs into their account
        #
        # @param token [String]
        # @param payer_id [Integer]
        # @param order [Object]
        def self.assign_paypal_token token, payer_id, order
            order.express_token = token
            order.express_payer_id = payer_id
            order.save(validate: false)
        end

        # Completes the order process by communicating with PayPal; receives a response and in turn creates the relevant transaction records,
        # sends a confirmation email and redirects the user.
        #
        # @param order [Object]
        # @param session [Object
        def self.complete order, session
          response = EXPRESS_GATEWAY.purchase(Store::Price.new(price: order.gross_amount, tax_type: 'net').singularize, 
                                              Payatron4000::Paypal.express_purchase_options(order)
          )
          Payatron4000.decommission_order(order)
          if response.success?
            Payatron4000::Paypal.successful(response, order)
            Payatron4000.destroy_cart(session)
            order.reload
            Mailatron4000::Orders.confirmation_email(order)
            return Rails.application.routes.url_helpers.success_order_url(order)
          else
            Payatron4000::Paypal.failed(response, order)
            order.reload
            Mailatron4000::Orders.confirmation_email(order)
            return Rails.application.routes.url_helpers.failed_order_url(order)
          end
        end

        # Upon successfully completing an order with a PayPal payment option a new transaction record is created, stock is updated for the relevant SKU
        #
        # @param response [Object]
        # @param order [Object]
        def self.successful response, order
            Transaction.new(  :fee                      => response.params['PaymentInfo']['FeeAmount'],  
                              :order_id                 => order.id, 
                              :payment_status           => response.params['PaymentInfo']['PaymentStatus'].downcase, 
                              :transaction_type         => 'Credit', 
                              :tax_amount               => response.params['PaymentInfo']['TaxAmount'], 
                              :paypal_id                => response.params['PaymentInfo']['TransactionID'], 
                              :payment_type             => response.params['PaymentInfo']['TransactionType'],
                              :net_amount               => response.params['PaymentInfo']['GrossAmount'].to_d - response.params['PaymentInfo']['TaxAmount'].to_d,
                              :gross_amount             => response.params['PaymentInfo']['GrossAmount'],
                              :status_reason            => response.params['PaymentInfo']['PendingReason']
            ).save(validate: false)
            Payatron4000.update_stock(order)
            Payatron4000.increment_product_order_count(order.products)
        end

        
        # When an order has failed to complete, a new transaction record is created with a logged status reason
        #
        # @param response [Object]
        # @param order [Object]
        def self.failed response, order
            Transaction.new(  :fee                        => 0, 
                              :gross_amount               => order.gross_amount, 
                              :order_id                   => order.id, 
                              :payment_status             => 'failed', 
                              :transaction_type           => 'Credit', 
                              :tax_amount                 => order.tax_amount, 
                              :paypal_id                  => nil, 
                              :payment_type               => 'express-checkout',
                              :net_amount                 => order.net_amount,
                              :status_reason              => response.message,
                              :error_code                 => response.params["error_codes"].to_i
            ).save(validate: false)
            Payatron4000.increment_product_order_count(order.products)
        end

        # A list of available currency codes for the PayPal payment system
        #
        # @return [Array] available currency codes
        def self.currency_codes
          return [
            "AUD",
            "CAD",
            "CZK",
            "DKK",
            "EUR",
            "HKD",
            "HUF",
            "ILS",
            "JPY",
            "MXN",
            "NOK",
            "NZD",
            "PHP",
            "PLN",
            "GBP",
            "RUB",
            "SGD",
            "SEK",
            "CHF",
            "TWD",
            "THB",
            "USD"
          ]
        end
    end
end