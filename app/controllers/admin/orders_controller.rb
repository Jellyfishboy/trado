class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @orders = Order.includes(:billing_address).active.order(created_at: :desc)
  end

  def show
    set_order
  end

  def edit
    set_order
    render json: { modal: render_to_string(partial: 'admin/orders/modal') }, status: 200
  end

  def update
    set_order
    if @order.update(params[:order])
      OrderMailer.updated_dispatched(@order).deliver_later if @order.changed_shipping_date?
      render json: 
      { 
        order_id: @order.id,
        date: @order.updated_at.strftime("%d/%m/%Y"),
        row: render_to_string(partial: 'admin/orders/single', locals: { order: @order })
      }, status: 200
    else 
      render json: { errors: @order.errors.full_messages }, status: 422
    end
  end
  
  private

  def set_order
    @order ||= Order.find(params[:id])
  end
end
