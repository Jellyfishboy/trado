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
          OrderMailer.received(transaction.order)
        end
      end
    end

    render :nothing => true
  end

  def edit
    @transaction = Transaction.find(params[:id])
    render :partial => 'admin/transactions/edit', :format => [:js]
  end

  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.js { render :partial => 'admin/transactions/success', :format => [:js] }
      end
    end
  end

end