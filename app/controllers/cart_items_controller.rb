class CartItemsController < ApplicationController
  skip_before_action :authenticate_user!
  after_action :set_delivery_session

  def create
  	set_sku
  	set_quantity
    reset_session
    increment_and_set_cart_item
    if @sku.valid_stock?(@quantity)
      render partial: theme_presenter.page_template_path('carts/update'), format: [:js] if @cart_item.save
    else
      render partial: theme_presenter.page_template_path('carts/cart_items/validate/failed'), format: [:js], object: @sku
    end
  end

  def update
    set_cart_item
    reset_session
    @accessory = @cart_item.cart_item_accessory ? @cart_item.cart_item_accessory.accessory : nil
    @cart_item.update_quantity(params[:cart_item][:quantity], @accessory)
    if @cart_item.quantity == 0 
      @cart_item.destroy 
    else
      @cart_item.update_weight(params[:cart_item][:quantity], @cart_item.sku.weight, @accessory)
      @cart_item.save!
    end
    if @quantity > @sku.stock
      render partial: theme_presenter.page_template_path('carts/cart_items/validate/failed'), format: [:js], object: @sku
    else
      render partial: theme_presenter.page_template_path('carts/update'), format: [:js]
    end
  end

  def destroy
  	set_cart_item
    reset_session
    @cart_item.destroy
    render partial: theme_presenter.page_template_path('carts/update'), format: [:js]
  end  

  private

  # TODO: Move this to an attribute on the cart model and trigger a sidekiq job after every item added
  #
  def reset_session
    session[:delivery_service_prices] = session[:payment_type] = nil
  end

  def set_delivery_session
    unless current_cart.cart_items.empty?
      session[:delivery_service_prices] = current_cart.calculate_delivery_services(Store.tax_rate)
    end
  end
  # 
  # END

  def set_sku
  	@sku ||= Sku.find(params[:cart_item][:sku_id])
  end

  def set_cart_item
  	@cart_item ||= CartItem.find(params[:id])
  end

  def set_quantity
  	@quantity = current_cart.cart_items.where(sku_id: @sku.id).sum(:quantity) + params[:cart_item][:quantity].to_i
  end

  def increment_and_set_cart_item
  	@cart_item = CartItem.increment(@sku, params[:cart_item][:quantity], params[:cart_item][:cart_item_accessory], current_cart)
  end

  def set_validate_cart_item
    # @cart_item = CartItem.find(params[:id]) unless params[:id].nil?
    # @sku = @cart_item.nil? ? Sku.find(params[:cart_item][:sku_id]) : @cart_item.sku
    # @quantity = params[:action] == 'create' ? () :  params[:cart_item][:quantity].to_i
  end
end
