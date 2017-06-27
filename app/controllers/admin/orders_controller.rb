class Admin::OrdersController < Admin::AdminBaseController
  include PaginationHelper
  before_action :authenticate_user!
  layout 'admin'

  def index
    set_delivery_status
    set_payment_type
    set_orders
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
    @order.validate_shipping_date!
    if @order.update(params[:order])
      OrderMailer.updated_dispatched(@order).deliver_later if @order.updated_delivery_details?
      render json: 
      { 
        order_id: @order.id,
        date: @order.shipping_date.strftime("%d/%m/%Y %R"),
        row: render_to_string(partial: 'admin/orders/single', locals: { order: @order }),
        dispatch_date: @order.shipping_date.strftime(" #{@order.shipping_date.day.ordinalize} %b %Y"),
        tracking: render_to_string(partial: 'admin/orders/tracking', locals: { order: @order })
      }, status: 200
    else 
      render json: { errors: @order.errors.full_messages }, status: 422
    end
  end

  def cancel
    set_order
    @order.cancelled!
    @order.restore_stock!
    redirect_to admin_orders_url
  end
  
  private

  def set_order
    @order ||= Order.complete.find(params[:id])
  end

  def set_orders
    @orders ||= Order.includes(:billing_address).complete.where(shipping_status: @delivery_status).where(payment_type: @payment_type).order(created_at: :desc).page(page).per(limit)
  end

  def set_delivery_status
    @delivery_status = params[:delivery_status].present? ? (params[:delivery_status] == "all" ? Order.shipping_statuses.values : (Order.shipping_statuses.values.include?(params[:delivery_status].to_i) ? params[:delivery_status] : Order.shipping_statuses.values)) : Order.shipping_statuses.values
  end

  def set_payment_type
    @payment_type = params[:payment_type].present? ? (params[:payment_type] == "all" ? Order.payment_types.values : (Order.payment_types.values.include?(params[:payment_type].to_i) ? params[:payment_type] : Order.payment_types.values)) : Order.payment_types.values
  end
end
