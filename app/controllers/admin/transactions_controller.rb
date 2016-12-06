class Admin::TransactionsController < ApplicationController
    before_action :authenticate_user!
    
    def show
        set_transaction
        render json: { modal: render_to_string(partial: 'admin/orders/transactions/modal', locals: { transaction: @transaction }) }, status: 200
    end

    private

    def set_transaction
        @transaction ||= Transaction.find(params[:id])
    end
end