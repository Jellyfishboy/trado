class Admin::OrdersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.where('status = ?', 'active').order('created_at desc').page(params[:page])
    respond_to do |format|
      format.js { render :partial => 'admin/orders/update_order', :format => [:js] }
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    begin
      @order = Order.find(params[:id])
    rescue
      @logged_error = "Attempts to access invalid order #{params[:id]}"
      Notifier.application_error(@logged_error, 'Order').deliver
      redirect_to store_url, :notice => 'Invalid order'
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @order }
      end
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        Notifier.order_updated(@order).deliver if params[:update_customer].to_i == 1
        format.html { redirect_to admin_order_path(@order), notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to admin_orders_path, notice: 'Your order has been deleted' }
      format.json { head :no_content }
    end
  end
end
