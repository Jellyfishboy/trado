class CartsController < ApplicationController

    skip_before_action :authenticate_user!

    def mycart
    end

    # TODO Need to calculate the net, tax, delivery and gross amount for the cart and transfer to the order once completed
    def checkout
        @order = Order.new
        @delivery_address = @order.build_delivery_address
        @billing_address = @order.build_billing_address
    end

    def estimate
        respond_to do |format|
          if current_cart.update(params[:cart])
            format.js { render partial: 'carts/delivery_service_prices/estimate/success', format: [:js] }
          else
            format.json { render json: { errors: @order.errors.to_json(root: true) }, status: 422 }
          end
        end
    end

    def purge_estimate
        current_cart.update_attributes(estimate_delivery_id: nil, estimate_country_id: nil)
        render :partial => 'carts/delivery_service_prices/estimate/success', :format => [:js]
    end
end