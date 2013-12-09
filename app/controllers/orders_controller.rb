class OrdersController < ApplicationController
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
    @cart = current_cart
    @order = Order.new(params[:order]) # want all the data from the form so select the :order hash
    @order.add_line_items_from_cart(current_cart)
    @order.calculate_order(current_cart)
    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        #Notifier.order_received(@order).deliver # pass the current @order into the method within Notifier class, then execute the delivery
        format.js { render :js => "window.location = '#{store_url}'", flash[:success] => 'You have completed your order. Please check your email for confirmation details.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.json { render :json => { :error => @order.errors.full_messages }, :status => 422 }
      end
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