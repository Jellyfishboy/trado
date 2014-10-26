# module Payatron4000

#     class Generic

#         # Upon successfully completing an order a new transaction record is created, stock is updated for the relevant SKU
#         #
#         # @param order[Object]
#         # @param payment_type [String]
#         def self.successful order, payment_type
#             Transaction.new( :fee => 0, 
#                 :gross_amount => order.gross_amount, 
#                 :order_id => order.id, 
#                 :payment_status => 'pending', 
#                 :transaction_type => 'Credit', 
#                 :tax_amount => order.tax_amount, 
#                 :paypal_id => nil, 
#                 :payment_type => payment_type,
#                 :net_amount => order.net_amount,
#                 :status_reason => nil
#             ).save(validate: false)
#             Payatron4000::update_stock(order)
#         end

#         # Completes the order process by creating a transaction record, sending a confirmation email and redirects the user
#         # Rollbar is notified with the relevant data if the email fails to send
#         #
#         # @param order [Object]
#         # @param payment_type [String]
#         # @param session [Object]
#         def self.complete order, payment_type, session
#             Payatron4000::Generic.successful(order, payment_type)
#             Payatron4000::destroy_cart(session)
#             order.reload
#             Mailatron4000::Orders.confirmation_email(order)
#             return Rails.application.routes.url_helpers.failed_order_url(order)
#         end
#     end
# end
