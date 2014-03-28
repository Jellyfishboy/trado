module Payatron4000

    class Paypal

        def self.express_setup_options(order, steps, cart, session, ip_address, return_url, cancel_url)
            {
              :subtotal          => Payatron4000.price_in_pennies(session[:sub_total]),
              :shipping          => Payatron4000.price_in_pennies(order.shipping.price),
              :tax               => Payatron4000.price_in_pennies(session[:tax]),
              :handling          => 0,
              :order_id          => order.id,
              :items             => Payatron4000::Paypal.express_items(cart),
              :ip                => ip_address,
              :return_url        => return_url,
              :cancel_return_url => cancel_url,
              :currency          => 'GBP',
            }
        end

        def self.express_purchase_options(order, session)
            {
              :subtotal          => Payatron4000.price_in_pennies(session[:sub_total]),
              :shipping          => Payatron4000.price_in_pennies(order.shipping.price),
              :tax               => Payatron4000.price_in_pennies(session[:tax]),
              :handling          => 0,
              :token             => order.express_token,
              :payer_id          => order.express_payer_id,
              :currency          => 'GBP'
            }
        end

        def self.express_items(cart)
            cart.cart_items.collect do |item|
                {
                    :name => item.sku.product.name,
                    :description => "#{item.sku.attribute_value}#{item.sku.attribute_type.measurement unless item.sku.attribute_type.measurement.nil? }",
                    :amount => Payatron4000.price_in_pennies(item.price), 
                    :quantity => item.quantity 
                }
            end
        end

        # assign paypal token to order after user logs into their account
        def self.assign_paypal_token(token, payer_id, session, order)
            details = EXPRESS_GATEWAY.details_for(token)
            order.update_attributes(:express_token => token, :express_payer_id => payer_id)
            order.save!
            session[:paypal_email] = details.params["payer"]
        end

        # Successful order
        def self.successful(response, order)
            # Create transaction
            Transaction.create( :fee => response.params['PaymentInfo']['FeeAmount'], 
                                :gross_amount => response.params['PaymentInfo']['GrossAmount'], 
                                :order_id => self.id, 
                                :payment_status => response.params['PaymentInfo']['PaymentStatus'], 
                                :payment_type => response.params['PaymentInfo']['PaymentType'], 
                                :tax_amount => response.params['PaymentInfo']['TaxAmount'], 
                                :transaction_id => response.params['PaymentInfo']['TransactionID'], 
                                :transaction_type => response.params['PaymentInfo']['TransactionType'],
                                :net_amount => response.params['PaymentInfo']['GrossAmount'].to_d - response.params['PaymentInfo']['TaxAmount'].to_d - self.shipping.price,
                                :status_reason => response.params['PaymentInfo']['PendingReason'])
            Payatron4000.stock_update(order)
            # Set order status to active
            order.update_column(:status, 'active')
        end

        # Failed order
        def self.failed(response, order)
            Transaction.create( :fee => 0, 
                                :gross_amount => session[:total], 
                                :order_id => self.id, 
                                :payment_status => 'Failed', 
                                :payment_type => '', 
                                :tax_amount => session[:tax], 
                                :transaction_id => '', 
                                :transaction_type => '',
                                :net_amount => session[:sub_total],
                                :status_reason => response.message)
            order.update_column(:status, 'active')
        end

    end
end