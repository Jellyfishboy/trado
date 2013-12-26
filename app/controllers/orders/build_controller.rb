class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  steps :review, :billing, :shipping, :payment, :confirm

  def show
    @cart = current_cart
    @order = Order.find(params[:order_id])
    case step
    when :shipping
      @calculated_tier = @order.calculate_shipping_tier(current_cart)
      @shipping_options = @order.display_shippings(@calculated_tier)
    end
    render_wizard
  end

  def update 
    @order = Order.find(params[:order_id])
    binding.pry
    params[:order][:status] = step.to_s # sets current state of form for the correct validation to trigger, i.e. the steps labeled above
    params[:order][:status] = 'active' if step == steps.last # sets the status as active on the last step so all validation is triggered
    @order.update_attributes(params[:order])
    case step
    when :shipping
      @calculated_tier = @order.calculate_shipping_tier(current_cart)
      @shipping_options = @order.display_shippings(@calculated_tier)
      @order.update_shipping_information
    end
    case step
    when :payment
      @order.calculate_order(current_cart)
    end
    case step
    when :confirm
      @order.add_line_items_from_cart(current_cart)
    end
    render_wizard @order
  end

private

  def redirect_to_finish_wizard
    redirect_to root_url, notice: "Thank you for your order."
  end

end