class OrdersController < ApplicationController
  include Wicked::Wizard

  steps :review, :billing, :shipping, :payment, :confirm
  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.create
    binding.pry
    redirect_to order_build_path(:order_id => @order.id, :id => steps.first)
    # @cart = current_cart 
    # if @cart.line_items.empty?
    #   redirect_to root_url, :notice => 'You cart is empty'
    #   return
    # end
  end

  # POST /orders
  # POST /orders.json
  def create
    # @order = Order.create
    # redirect_to wizard_path(steps.first, :product_id => @product.id)
    # @cart = current_cart
    # @order = Order.new(params[:order]) # want all the data from the form so select the :order hash
    # @order.add_line_items_from_cart(current_cart)
    # @order.calculate_order(current_cart)
    # respond_to do |format|
    #   if @order.save
    #     Cart.destroy(session[:cart_id])
    #     session[:cart_id] = nil
    #     Notifier.order_received(@order).deliver # pass the current @order into the method within Notifier class, then execute the delivery
    #     format.js { render :js => "window.location = '#{store_url}'", flash[:success] => 'You have completed your order. Please check your email for confirmation details.' }
    #     format.json { render json: @order, status: :created, location: @order }
    #   else
    #     format.json { render :json => { :error => @order.errors.full_messages }, :status => 422 }
    #   end
    # end
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