class CartItemsController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :set_validate_cart_item, except: :destroy
  before_action :void_delivery_services
  after_action :set_delivery_services

  def create
    @sku = Sku.find(params[:cart_item][:sku_id])
    @cart_item = CartItem.increment(@sku, params[:cart_item][:quantity], params[:cart_item][:cart_item_accessory], current_cart)
    render partial: 'carts/update', format: [:js] if @cart_item.save
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
    render partial: 'carts/update', format: [:js]
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    render partial: 'carts/update', format: [:js]
  end  

  private

    def void_delivery_services
      unless current_cart.estimate_delivery_id.nil? || current_cart.delivery_service_prices.nil? 
        current_cart.update_attributes(estimate_delivery_id: nil, estimate_country_name: nil, delivery_service_prices: nil)
      end
    end

    def set_delivery_services
      current_cart.calculate_delivery_services
    end

    def set_validate_cart_item
      @cart_item = CartItem.find(params[:id]) unless params[:id].nil?
      @sku = @cart_item.nil? ? Sku.find(params[:cart_item][:sku_id]) : @cart_item.sku
      @quantity = params[:action] == 'create' ? ((current_cart.cart_items.where(sku_id: @sku.id).sum(:quantity)) + params[:cart_item][:quantity].to_i) :  params[:cart_item][:quantity].to_i
      if @quantity > @sku.stock
        render partial: 'carts/cart_items/validate/failed', format: [:js], object: @sku
        return false
      end
    end
end
