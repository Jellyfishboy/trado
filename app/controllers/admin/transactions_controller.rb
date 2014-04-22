class Admin::TransactionsController < ApplicationController

  before_filter :authenticate_user!, :except => :paypal_ipn
  layout 'admin'

  include ActiveMerchant::Billing::Integrations

  # Handler for incoming Instant Payment Notifications from paypal about orders
  def paypal_ipn
    notify = Paypal::Notification.new(request.raw_post)
    
    if notify.acknowledge
      transaction = Transaction.where('order_id = ?', notify.params['invoice']).first
      begin

        if notify.complete? and transaction.gross_amount = notify.params['mc_gross']
          transaction.fee = notify.params['mc_fee']
          transaction.payment_status = notify.params['payment_status']
        end
        # TODO: Possibly log failed paypal verifications in future?

      rescue => e
        transaction.payment_status = 'Failed'
        raise
      ensure
        if transaction.save
          Notifier.order_received(transaction.order)
        end
      end
    end

    render :nothing => true
  end

end