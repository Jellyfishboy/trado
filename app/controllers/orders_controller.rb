class OrdersController < ApplicationController
  include Wicked::Wizard

  steps :review, :billing, :shipping, :payment, :confirm
  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.create
    redirect_to order_build_path(:order_id => @order.id, :id => steps.first)
  end

  def update_line_item 
    respond_to do |format|
      format.js { render :partial => 'carts/update_cart', :format => [:js] }
    end
  end

  def update_country
    @tier = Tier.find(params[:tier_id])
    @new_shippings = @tier.shippings.joins(:countries).where('country_id = ?', params[:country_id]).all
    render :partial => "orders/update_country", :object => @new_shippings
  end
end