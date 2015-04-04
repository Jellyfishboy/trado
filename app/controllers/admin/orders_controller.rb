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
    render partial: 'admin/orders/dispatch/dispatcher', format: [:js]
  end

  def dispatched
    respond_to do |format|
      @order.shipping_date = Time.now
      @order.shipping_status = 'dispatched'
      if @order.update(params[:order])
        OrderMailer.dispatched(@order).deliver_later
        format.js { render partial: 'admin/orders/dispatch/dispatched', format: [:js] }
      end
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

end
