class Admin::TransactionsController < ApplicationController
  layout 'admin'
  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Tranasaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end
  end
end