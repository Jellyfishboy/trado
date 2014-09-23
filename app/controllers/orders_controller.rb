class OrdersController < ApplicationController

    skip_before_action :authenticate_user!
    before_action :set_order, except: [:confirm, :success, :failed]

    # def new
    #   if current_cart.cart_items.empty?
    #     flash_message :notice, "Your cart is empty."
    #     redirect_to root_url
    #   else
    #     if current_cart.order.nil? 
    #       @order = Order.create(ip_address: request.remote_ip, cart_id: current_cart.id)
    #     else
    #       @order = current_cart.order
    #     end
    #     Shipatron4000::delivery_prices(current_cart, @order)
    #     redirect_to order_build_path(:order_id => @order.id, :id => steps.first)
    #   end
    # end  

    def confirm
      @order = Order.new(params[:order])

      respond_to do |format|
        if @order.save
          
        else
          format.json { render json: { errors: @order.errors.to_json(root: true) }, status: 422 }
        end
    end

    def complete

    end

    def success
      @order = Order.includes(:delivery_address).find(params[:order_id])
      redirect_to root_url unless @order.transactions.last.pending? || @order.transactions.last.completed?
    end

    def failed
      @order = Order.includes(:transactions).find(params[:id])
      redirect_to root_url unless @order.transactions.last.failed?
    end

    def retry
      @error_code = @order.transactions.last.error_code
      @order.update_column(:cart_id, session[:cart_id]) unless @error_code == 10412 || @error_code == 10415
      redirect_to mycart_carts_url
    end

    def destroy
      @order.update_column(:cart_id, nil)
      flash_message :success, "Your order has been cancelled."
      redirect_to root_url
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end
end