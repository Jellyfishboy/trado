class CartItemsController < ApplicationController
	skip_before_action :authenticate_user!

	def create
		set_sku
		set_create_quantity
		if @sku.valid_stock?(@quantity)
			set_and_adjust_cart_item(params[:cart_item][:quantity])
			render partial: theme_presenter.page_template_path('carts/update'), format: [:js]
		else
			render partial: theme_presenter.page_template_path('carts/cart_items/validate/failed'), format: [:js], object: @sku
		end
	end

	def update
		set_cart_item
		set_update_quantity
		set_accessory
		if @cart_item.sku.valid_stock?(@quantity)
			set_and_adjust_cart_item(params[:cart_item][:quantity].to_i - @cart_item.quantity)
			render partial: theme_presenter.page_template_path('carts/update'), format: [:js]
		else
			render partial: theme_presenter.page_template_path('carts/cart_items/validate/failed'), format: [:js], object: @sku
		end
	end

	def destroy
		set_cart_item
		reset_session
		@cart_item.destroy
		render partial: theme_presenter.page_template_path('carts/update'), format: [:js]
	end  

	private

  	def set_sku
  		@sku = Sku.find(params[:cart_item][:sku_id]) 
  	end

  	def set_cart_item
  		@cart_item ||= CartItem.find(params[:id])
  	end

  	def set_create_quantity
  		@quantity = current_cart.cart_items.where(sku_id: @sku.id).sum(:quantity) + params[:cart_item][:quantity].to_i
  	end

  	def set_update_quantity
  		@quantity = current_cart.cart_items.where(sku_id: @cart_item.sku.id).sum(:quantity) + (params[:cart_item][:quantity].to_i - @cart_item.quantity)
  	end

  	def set_accessory
		@accessory = @cart_item.cart_item_accessory.accessory unless @cart_item.cart_item_accessory.nil?
	end

  	def set_and_adjust_cart_item quantity
  		@cart_item = CartItem.adjust(@sku ||= @cart_item.sku, quantity, params[:cart_item][:cart_item_accessory], current_cart)
  	end
end
