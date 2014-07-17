class OrdersController < ApplicationController
  include Wicked::Wizard

  skip_before_action :authenticate_user!

  steps :review, :billing, :shipping, :payment, :confirm

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
end