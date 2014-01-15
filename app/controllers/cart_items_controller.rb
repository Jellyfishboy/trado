class CartItemsController < ApplicationController

  skip_before_filter :authenticate_user!

  # POST /cart_items
  # POST /cart_items.json
  def create
    @cart = current_cart #references the current cart which was defined in application controller
    sku = Sku.find(params[:cart_item][:sku_id])
    # params[:accessory_id].any? ? params[:accessory_id] : nil
    # @cart_accessory_item = @cart.add_accessory_cart_item
    @cart_item = @cart.add_cart_item(sku.weight, sku.price, sku.id, params[:cart_item][:quantity]) #uses add_cart_item method in cart.rb to check if the cart item already exists in the cart and responds accordingly
    respond_to do |format|
      if sku.stock >= @cart_item.quantity #checks to make sure the requested quantity is not more than the current DB stock
        if @cart_item.save
          format.js { render :partial => 'carts/update_cart', :formats => [:js] }
        else
          format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        end
      else
        format.js { render :partial => 'carts/insufficient_stock', :formats => [:js], :object => @cart_item }
      end
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
      respond_to do |format|
        if @cart_item.sku.stock >= params[:cart_item][:quantity].to_i #checks to make sure the requested quantity is not more than the current DB stock
          if @cart_item.update_attributes(params[:cart_item])
            if @cart_item.quantity == 0 
              @cart_item.destroy
            end
            format.js { render :partial => 'carts/update_cart', :format => [:js] }
            format.json { head :no_content }
          else
            format.json { render json: @category.errors, status: :unprocessable_entity }
          end
        else
          format.js { render :partial => 'carts/insufficient_stock', :formats => [:js], :object => @cart_item }
        end
      end
  end

  # DELETE /cart_items/1
  # DELETE /cart_items/1.json
  def destroy
    @cart = current_cart
    cart_item = CartItem.find(params[:id])
    @cart_item = @cart.decrement_cart_item_quantity(cart_item.id)

    respond_to do |format|
      if @cart_item.save
        format.html { redirect_to store_url, notice: 'Successfully deleted the item.' }
        format.js { render :partial => 'carts/update_cart', :formats => [:js] }
        format.json { head :no_content }
      end
    end
  end  
end
