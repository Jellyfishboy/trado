class OrdersController < ApplicationController
  layout 'admin', :except => :new
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.order('created_at desc').page(params[:page])
    respond_to do |format|
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

  # GET /orders/new
  # GET /orders/new.json
  def new
    @cart = current_cart 
    if @cart.line_items.empty?
      redirect_to store_url, :notice => 'You cart is empty'
      return
    end
    @order = Order.new
    @calculated_tier = @order.calculate_shipping_tier(current_cart)
    @shipping_options = Tier.find(@calculated_tier).first
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @cart = current_cart
    @order = Order.new(params[:order]) # want all the data from the form so select the :order hash
    @order.add_line_items_from_cart(current_cart)
    @order.total = current_cart.total_price # calculate total price for all the items
    @order.uk_vat # utitlise the uk_vat method to calulcate and populate the total_vat field (total + vat) and calculate the vat amount to populate the vat field
    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        #Notifier.order_received(@order).deliver # pass the current @order into the method within Notifier class, then execute the delivery
        format.html { redirect_to store_url, notice: 'Thank you for your order.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
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
      format.html { redirect_to orders_path, notice: 'Your order has been deleted' }
      format.json { head :no_content }
    end
  end
end
