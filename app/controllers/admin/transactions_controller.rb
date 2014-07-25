class Admin::TransactionsController < ApplicationController

  skip_before_action :authenticate_user!

  include ActiveMerchant::Billing::Integrations

  # Handler for incoming Instant Payment Notifications from paypal about orders
  def paypal_ipn
    notify = Paypal::Notification.new(request.raw_post)
    
    if notify.acknowledge
      transaction = Transaction.where('order_id = ?', notify.params['invoice']).first
      if notify.complete? and transaction.gross_amount.to_s == notify.params['mc_gross']
        transaction.fee = notify.params['mc_fee']
        transaction.completed!
      else
        transaction.failed!
      end
      if transaction.save
        Mailatron4000::Orders.confirmation_email(transaction.order) rescue Rollbar.report_message("PayPal IPN: Order #{transaction.order.id} confirmation email failed to send", "info", :order => transaction.order)
      end
    end

    render nothing: true
  end
end