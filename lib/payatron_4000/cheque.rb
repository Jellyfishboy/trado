module Payatron4000

    class Cheque

        # Upon successfully completing an order with a Cheque payment option a new transaction record is created, stock is updated for the relevant SKU
        # and order status attribute set to active
        #
        # @parameter [hash object]
        def self.successful(order)
            Transaction.create( :fee => nil, 
                                :gross_amount => order.gross_amount, 
                                :order_id => order.id, 
                                :payment_status => 'Pending', 
                                :transaction_type => 'Credit', 
                                :tax_amount => order.tax_amount, 
                                :paypal_id => nil, 
                                :payment_type => 'Cheque',
                                :net_amount => order.net_amount,
                                :status_reason => nil
            )
            Payatron4000::stock_update(order)
            order.update_column(:status, 'active')
        end

    end
end