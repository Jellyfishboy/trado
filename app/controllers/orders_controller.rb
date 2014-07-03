class OrdersController < ApplicationController
  include Wicked::Wizard

  skip_before_filter :authenticate_user!

  steps :review, :billing, :shipping, :payment, :confirm
  # GET /orders/new
  # GET /orders/new.json
  def new
    if current_cart.cart_items.empty?
      flash_message :notice, "Your cart is empty."
      redirect_to root_url
    else
      if current_cart.order.nil? 
        @order = Order.create(ip_address: request.remote_ip, cart_id: current_cart.id)
      else
        @order = current_cart.order
      end
      redirect_to order_build_path(:order_id => @order.id, :id => steps.first)
    end
  end

  def update
    @order = Order.find(params[:order_id])
    binding.pry
    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.js { render partial: 'orders/estimate/success', format: [:js] }
      else
        format.json { render json: { error: @order.errors.full_messages }, status: 422 }
      end
    end
  end
  
end