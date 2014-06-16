module Payatron4000

    class Generic

        # Upon successfully completing an order a new transaction record is created, stock is updated for the relevant SKU
        # and order status attribute set to active
        #
        # @param order[Object]
        # @param payment_type [String]
        def self.successful order, payment_type
            Transaction.new( :fee => 0, 
                                :gross_amount => order.gross_amount, 
                                :order_id => order.id, 
                                :payment_status => 'Pending', 
                                :transaction_type => 'Credit', 
                                :tax_amount => order.tax_amount, 
                                :paypal_id => nil, 
                                :payment_type => payment_type,
                                :net_amount => order.net_amount,
                                :status_reason => nil
            ).save(validate: false)
            Payatron4000::stock_update(order)
            order.update_column(:status, 'active')
        end

        # Completes the order process by creating a transaction record, sending a confirmation email and redirects the user
        # Rollbar is notified with the relevant data if the email fails to send
        #
        # @param order [Object]
        # @param payment_type [String]
        # @param session [Object]
        def self.complete order, payment_type, session
            Payatron4000::Generic.successful(order, payment_type)
            Payatron4000::destroy_cart(session)
            order.reload
            begin
                Mailatron4000::Orders.confirmation_email(order)
            rescue
                Rollbar.report_message("Order #{order.id} confirmation email failed to send", "info", :order => order)
            end
            return Rails.application.routes.url_helpers.success_order_build_url(:order_id => order.id, :id => 'confirm')
        end
    end
end
