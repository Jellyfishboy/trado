class Admin::OrdersController < ApplicationController

  layout 'admin'
  before_filter :authenticate_user!

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.includes(:transactions).where('status = ?', 'active').order('orders.created_at desc')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  def edit
    @order = Order.find(params[:id])
    render :partial => 'admin/orders/edit', :format => [:js]
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])
    
    respond_to do |format|
      begin
        @order.shipping_date = DateTime.strptime(params[:order][:shipping_date], "%d/%m/%Y").to_time if params[:order][:shipping_date]
      rescue
         format.json { render :json => { :errors => ['Shipping date can\'t be blank'] }, :status => 422 }
      end
      if @order.update_attributes(params[:order])
        format.js { render :partial => 'admin/orders/success', :format => [:js] }
      else 
        format.json { render :json => { :errors => @order.errors.full_messages }, :status => 422 }
      end
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # Set the shipping dispatch date for an order
  #
  # @return [nil]
  def shipping
    @order = Order.find(params[:id])
    render :partial => 'admin/orders/shipping/edit', :format => [:js]
  end

end
