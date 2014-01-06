class OrdersController < ApplicationController
  include Wicked::Wizard

  steps :review, :billing, :shipping, :payment, :confirm
  # GET /orders/new
  # GET /orders/new.json
  def new
    if current_cart.line_items.empty?
      redirect_to root_url, flash[:notice] => "Your cart is empty."
    else
      @order = Order.create
      redirect_to order_build_path(:order_id => @order.id, :id => steps.first)
    end
  end

  def update_country
    @tier = Tier.find(params[:tier_id])
    @new_shippings = @tier.shippings.joins(:countries).where('country_id = ?', params[:country_id]).all
    render :partial => "orders/update_country", :object => @new_shippings
  end
end