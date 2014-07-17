class Admin::OrdersController < ApplicationController

  before_action :set_order, only: [:show, :edit, :update]
  before_action :authenticate_user!
  layout 'admin'

  def index
    @orders = Order.includes(:transactions).where('status = ?', 'active').order('orders.created_at DESC')
    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
  end

  def show
    
    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def edit
    render :partial => 'admin/orders/edit', :format => [:js]
  end

  def update

    respond_to do |format|
      begin
        @order.shipping_date = DateTime.strptime(params[:order][:shipping_date], "%d/%m/%Y").to_time if params[:order][:shipping_date]
      rescue
         format.json { render :json => { :errors => ['Shipping date can\'t be blank'] }, :status => 422 }
      end
      if @order.update(params[:order])
        format.js { render :partial => 'admin/orders/success', :format => [:js] }
      else 
        format.json { render :json => { :errors => @order.errors.full_messages }, :status => 422 }
      end
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

end
