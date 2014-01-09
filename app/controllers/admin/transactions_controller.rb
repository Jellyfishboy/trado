class Admin::TransactionsController < ApplicationController
  layout 'admin'
  include ActiveMerchant::Billing::Integrations
  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.order('updated_at desc').all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end
  end

  # Handler for incoming Instant Payment Notifications from paypal about orders
  def paypal_ipn
    notify = Paypal::Notification.new(request.raw_post)

    if notify.acknowledge
      transaction = Transaction.where('transaction_id = ?', notify.transaction_id)
      begin

        if notify.complete? and transaction.gross_amount = notify.amount
          transaction.payment_status = notify.status
        else
          Notifier.failed_paypal_verification(notify)
        end

      rescue => e
        transaction.payment_status = 'Failed'
        raise
      ensure
        transaction.save
      end
    end

    render :nothing => true
  end
end