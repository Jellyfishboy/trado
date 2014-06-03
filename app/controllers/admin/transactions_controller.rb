class Admin::TransactionsController < ApplicationController

  skip_before_filter :authenticate_user!

  include ActiveMerchant::Billing::Integrations

  # Handler for incoming Instant Payment Notifications from paypal about orders
  def paypal_ipn
    notify = Paypal::Notification.new(request.raw_post)
    
    if notify.acknowledge
      transaction = Transaction.where('order_id = ?', notify.params['invoice']).first
      begin

        if notify.complete? and transaction.gross_amount.to_s == notify.params['mc_gross']
          transaction.fee = notify.params['mc_fee']
          transaction.payment_status = notify.params['payment_status']
        end
        # TODO: Possibly log failed paypal verifications in future?

      rescue => e
        transaction.payment_status = 'Failed'
        raise
      ensure
        if transaction.save
          OrderMailer.received(transaction.order)
        end
      end
    end

    render :nothing => true
  end
end