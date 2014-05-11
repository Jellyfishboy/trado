module Payatron4000

    class Generic

        # Upon successfully completing an order a new transaction record is created, stock is updated for the relevant SKU
        # and order status attribute set to active
        #
        # @parameter [hash object, string]
        def self.successful order, payment_type
            Transaction.create( :fee => 0, 
                                :gross_amount => order.gross_amount, 
                                :order_id => order.id, 
                                :payment_status => 'Pending', 
                                :transaction_type => 'Credit', 
                                :tax_amount => order.tax_amount, 
                                :paypal_id => nil, 
                                :payment_type => payment_type,
                                :net_amount => order.net_amount,
                                :status_reason => nil
            )
            Payatron4000::stock_update(order)
            order.update_column(:status, 'active')
        end

        # Completes the order process by creating a transaction record,
        # sending a confirmation email and redirects the user
        #
        # @parameter [hash object, string, hash object, hash_object]
        def self.complete order, payment_type, session, steps
            Payatron4000::Generic.successful(order, payment_type)
            Payatron4000::destroy_cart(session)
            order.reload
            Payatron4000::confirmation_email(order, order.transactions.last.payment_status)
            redirect_to Rails.application.routes.url_helpers.success_order_build_url(  :order_id => order.id, 
                                                                                       :id => steps.last
            )
        end
    end
end
