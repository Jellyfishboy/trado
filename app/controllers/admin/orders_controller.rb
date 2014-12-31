class Admin::OrdersController < ApplicationController

  before_action :set_order, only: [:show, :edit, :update]
  before_action :authenticate_user!
  layout 'admin'

  def index
    @orders = Order.active.order(created_at: :desc)
  end

  def show
  end

  def edit
    render partial: 'admin/orders/edit', format: [:js]
  end

  def update
    respond_to do |format|
      unless params[:order][:shipping_date].blank?
        @order.shipping_date = DateTime.strptime(params[:order][:shipping_date], "%d/%m/%Y").to_time

        if @order.update(params[:order])
          format.js { render partial: 'admin/orders/update', format: [:js] }
        else 
          format.json { render json: { errors: @order.errors.full_messages }, status: 422 }
        end
      else
         format.json { render json: { errors: ['Shipping date can\'t be blank'] }, status: 422 }
      end
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

end
