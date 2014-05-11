module Payatron4000

    class Paypal

        def self.express_setup_options order, steps, cart, ip_address, return_url, cancel_url
            {
              :subtotal          => Payatron4000::singularize_price(order.net_amount - order.shipping.price),
              :shipping          => Payatron4000::singularize_price(order.shipping.price),
              :tax               => Payatron4000::singularize_price(order.tax_amount),
              :handling          => 0,
              :order_id          => order.id,
              :items             => Payatron4000::Paypal.express_items(cart),
              :ip                => ip_address,
              :return_url        => return_url,
              :cancel_return_url => cancel_url,
              :currency          => 'GBP',
            }
        end

        def self.express_purchase_options order
            {
              :subtotal          => Payatron4000::singularize_price(order.net_amount - order.shipping.price),
              :shipping          => Payatron4000::singularize_price(order.shipping.price),
              :tax               => Payatron4000::singularize_price(order.tax_amount),
              :handling          => 0,
              :token             => order.express_token,
              :payer_id          => order.express_payer_id,
              :currency          => 'GBP'
            }
        end

        def self.express_items cart
            cart.cart_items.collect do |item|
                {
                    :name => item.sku.product.name,
                    :description => "#{item.sku.attribute_value}#{item.sku.attribute_type.measurement unless item.sku.attribute_type.measurement.nil? }",
                    :amount => Payatron4000::singularize_price(item.price), 
                    :quantity => item.quantity 
                }
            end
        end

        # assign paypal token to order after user logs into their account
        def self.assign_paypal_token token, payer_id, session, order
            details = EXPRESS_GATEWAY.details_for(token)
            order.update_attributes(:express_token => token, :express_payer_id => payer_id)
            order.save!
            session[:paypal_email] = details.params["payer"]
        end

        def self.complete order, steps
          response = EXPRESS_GATEWAY.purchase(Payatron4000::singularize_price(order.gross_amount), 
                                              Payatron4000::Paypal.express_purchase_options(order)
          )
          order.transfer(current_cart) if order.transactions.blank?
          if response.success?
            Payatron4000::destroy_cart(session)
            begin 
              Payatron4000::Paypal.successful(response, order)
            rescue Exception => e
              Rollbar.report_exception(e)
            end
            # order email
            if order.transactions.last.payment_status == "Pending"
              OrderMailer.pending(order).deliver
            else
              OrderMailer.received(order).deliver
            end
            redirect_to success_order_build_url(:order_id => order.id, 
                                                :id => steps.last
            )
          else
            begin
              Payatron4000::Paypal.failed(response, order)
            rescue Exception => e
              Rollbar.report_exception(e)
            end
            redirect_to failure_order_build_url(:order_id => order.id, 
                                                :id => steps.last, 
                                                :response => response.message, 
                                                :error_code => response.params["error_codes"]
            )
          end
        end

        # Upon successfully completing an order with a PayPal payment option a new transaction record is created, stock is updated for the relevant SKU
        # and order status attribute set to active
        # @parameter [object, hash object]
        #
        def self.successful response, order
            # Create transaction
            Transaction.create( :fee => response.params['PaymentInfo']['FeeAmount'], 
                                :gross_amount => response.params['PaymentInfo']['GrossAmount'], 
                                :order_id => order.id, 
                                :payment_status => response.params['PaymentInfo']['PaymentStatus'], 
                                :transaction_type => 'Credit', 
                                :tax_amount => response.params['PaymentInfo']['TaxAmount'], 
                                :paypal_id => response.params['PaymentInfo']['TransactionID'], 
                                :payment_type => response.params['PaymentInfo']['TransactionType'],
                                :net_amount => response.params['PaymentInfo']['GrossAmount'].to_d - response.params['PaymentInfo']['TaxAmount'].to_d,
                                :status_reason => response.params['PaymentInfo']['PendingReason']
            )
            Payatron4000::stock_update(order)
            # Set order status to active
            order.update_column(:status, 'active')
        end

        # Failed order
        def self.failed response, order
            Transaction.create( :fee => 0, 
                                :gross_amount => order.gross_amount, 
                                :order_id => order.id, 
                                :payment_status => 'Failed', 
                                :transaction_type => 'Credit', 
                                :tax_amount => order.tax_amount, 
                                :paypal_id => '', 
                                :payment_type => 'express-checkout',
                                :net_amount => order.net_amount,
                                :status_reason => response.message)
            order.update_column(:status, 'active')
        end

    end
end