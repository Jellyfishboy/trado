class Admin::OrdersController < ApplicationController
  before_action :set_order, except: :index
  before_action :authenticate_user!
  layout 'admin'

  def index
    @orders = Order.active.order(created_at: :desc)
  end

  def show
  end

  def edit
    render json: { modal: render_to_string(partial: 'admin/orders/modal') }, status: 200
  end

  def update
    if @order.update(params[:order])
      render json: { order_id: @order.id }, status: 200
      OrderMailer.tracking(@order).deliver_later if @order.new_order_tracking_mailer?
    else 
      render json: { errors: @order.errors.full_messages }, status: 422
    end
  end

  def dispatcher
    set_order
    render json: { modal: render_to_string(partial: 'admin/orders/dispatch/modal', locals: { order: @order }) }, status: 200
  end

  def dispatched
    @order.shipping_date = Time.now
    @order.shipping_status = 'dispatched'
    if @order.update(params[:order])
      OrderMailer.dispatched(@order).deliver_later
      render json: 
      { 
        order_id: @order.id, 
        date: @order.updated_at.strftime("%d/%m/%Y"), 
        row: render_to_string(partial: 'admin/orders/single', locals: { order: @order }) 
      }, status: 200
    end
  end

  private

    def set_order
      @order ||= Order.find(params[:id])
    end

end
