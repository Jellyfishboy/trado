class CartItemsController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :set_validate_cart_item, except: :destroy
  before_action :void_delivery_service
  after_action :set_order_delivery_services

  def create
    @sku = Sku.find(params[:cart_item][:sku_id])
    @cart_item = CartItem.increment(@sku, params[:cart_item][:quantity], params[:cart_item][:cart_item_accessory], current_cart)
    render partial: theme_presenter.page_template_path('carts/update'), format: [:js] if @cart_item.save
  end

  def update
    @accessory = @cart_item.cart_item_accessory ? @cart_item.cart_item_accessory.accessory : nil
    @cart_item.update_quantity(params[:cart_item][:quantity], @accessory)
    if @cart_item.quantity == 0 
      @cart_item.destroy 
    else
      @cart_item.update_weight(params[:cart_item][:quantity], @cart_item.sku.weight, @accessory)
      @cart_item.save!
    end
    render partial: theme_presenter.page_template_path(partial: 'carts/update'), format: [:js]
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    render partial: theme_presenter.page_template_path('carts/update'), format: [:js]
  end  

  private

    def void_delivery_service
      order = current_cart.order
      unless order.nil? || order.delivery_id.nil? || order.delivery_service_prices.nil?
        order.delivery_id = nil
        order.delivery_address.country = nil
        order.delivery_service_prices = nil
        order.save(validate: false)
      end
    end

    def set_order_delivery_services
      order = current_cart.order
      Shipatron4000::delivery_prices(current_cart, order) unless order.nil?
    end

    def set_validate_cart_item
      @cart_item = CartItem.find(params[:id]) unless params[:id].nil?
      @sku = @cart_item.nil? ? Sku.find(params[:cart_item][:sku_id]) : @cart_item.sku
      @quantity = params[:action] == 'create' ? ((current_cart.cart_items.where(sku_id: @sku.id).sum(:quantity)) + params[:cart_item][:quantity].to_i) :  params[:cart_item][:quantity].to_i
      if @quantity > @sku.stock
        render partial: theme_presenter.page_template_path('carts/cart_items/validate/failed'), format: [:js], object: @sku
        return false
      end
    end
end
