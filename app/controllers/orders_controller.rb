class OrdersController < ApplicationController
  # GET /orders/new
  # GET /orders/new.json
  def new
    @cart = current_cart 
    if @cart.line_items.empty?
      redirect_to root_url, :notice => 'You cart is empty'
      return
    end
    session[:order_params] ||= {}
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]
    @calculated_tier = @order.calculate_shipping_tier(current_cart)
    @shipping_options = @order.display_shippings(@calculated_tier)
    @order.calculate_order(current_cart)
    respond_to do |format|
      format.js { render :partial => 'orders/update_shipping', :format => [:js] }
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # POST /orders
  # POST /orders.json
  def create
    # FIXME: This is very long and cumbersome controller method. NEEDS TO BE REVISED POST V1!
    session[:order_params].deep_merge!(params[:order]) if params[:order]
    @cart = current_cart
    @order = Order.new(params[:order_params]) # want all the data from the form so select the :order hash
    @order.current_step = session[:order_step]
    @order.add_line_items_from_cart(current_cart)
    @order.calculate_order(current_cart)
    if @order.valid? # check order is valid
      if params[:back_button] #check if back button is pressed
        @order.previous_step
      elsif @order.last_step? #check if it is the last step, if so save and send email
        if @order.all_valid?
          @order.save
          Cart.destroy(session[:cart_id])
          session[:cart_id] = nil
          Notifier.order_received(@order).deliver
        end
      else # otherwise it has to be a next step request
        @order.next_step
      end
      # update session to current_step
      session[:order_step] = @order.current_step
    end
    if @order.new_record? # if new record, render new template
      render "new"
    else # else clear the session values ready for the next order and redirect with a notice
      session[:order_step] = session[:order_params] = nil
      flash[:notice] = "Order saved!"
      redirect_to root_url
    end
  end

  def update_line_item 
    respond_to do |format|
      format.js { render :partial => 'carts/update_cart', :format => [:js] }
    end
  end

  def success

    respond_to do |format|
      format.html
    end
  end

  def failure

    respond_to do |format|
      format.html
    end
  end

  def update_country
    @tier = Tier.find(params[:tier_id])
    @new_shippings = @tier.shippings.joins(:countries).where('country_id = ?', params[:country_id]).all
    render :partial => "orders/update_country", :object => @new_shippings
  end
end