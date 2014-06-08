class CartItemsController < ApplicationController

  skip_before_filter :authenticate_user!

  # POST /cart_items
  # POST /cart_items.json
  def create
    @sku = Sku.find(params[:cart_item][:sku_id])
    @cart_item = CartItem.increment!(@sku, params[:cart_item][:quantity], params[:cart_item][:cart_item_accessory], current_cart)
    # Need to query the database again since it will need to retrieve the quantity sum of cart_items with accessories and without accessories
    @quantity = current_cart.cart_items.where('sku_id = ?', @cart_item.sku_id).sum(:quantity) + @cart_item.quantity
    respond_to do |format|
      if @sku.stock >= @quantity #checks to make sure the requested quantity is not more than the current DB stock
        if @cart_item.save
          format.js { render :partial => 'carts/update', :formats => [:js] }
        else
          format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        end
      else
        format.js { render :partial => 'carts/insufficient_stock/update', :formats => [:js] }
      end
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @quantity = current_cart.cart_items.where('sku_id = ? AND id != ?', @cart_item.sku_id, @cart_item.id).sum(:quantity) + params[:cart_item][:quantity].to_i
      respond_to do |format|
        if @cart_item.sku.stock >= @quantity #checks to make sure the requested quantity is not more than the current DB stock
          if @cart_item.update_attributes(params[:cart_item])
            if @cart_item.quantity == 0 
              @cart_item.destroy 
            else
              accessory = @cart_item.cart_item_accessory ? @cart_item.cart_item_accessory.accessory : nil
              @cart_item.update_weight(params[:cart_item][:quantity], @cart_item.sku.weight, accessory)
              @cart_item.cart_item_accessory.quantity = params[:cart_item][:quantity] unless @cart_item.cart_item_accessory.nil?
              @cart_item.save!
            end
            format.js { render :partial => 'carts/update', :format => [:js] }
            format.json { head :no_content }
          else
            format.json { render json: @cart_item.errors, status: :unprocessable_entity }
          end
        else
          format.js { render :partial => 'carts/insufficient_stock/update', :formats => [:js] }
        end
      end
  end

  # DELETE /cart_items/1
  # DELETE /cart_items/1.json
  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.decrement!
    
    respond_to do |format|
      if @cart_item.save
        format.js { render :partial => 'carts/update', :formats => [:js] }
        format.json { head :no_content }
      end
    end
  end  
end
