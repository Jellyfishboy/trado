class CartItemsController < ApplicationController

  before_action :set_cart_item, except: :create
  skip_before_action :authenticate_user!
  before_action :void_shipping

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
    @cart_item.destroy
    render partial: 'carts/update', format: [:js]
  end  

  private

    def set_cart_item
      @cart_item = CartItem.find(params[:id])
    end

    def void_shipping
      current_cart.order.update_column(:shipping_id, nil) unless current_cart.order.nil? || current_cart.order.shipping_id.nil?
    end
end
