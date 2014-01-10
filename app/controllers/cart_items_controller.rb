class CartItemsController < ApplicationController

  # POST /cart_items
  # POST /cart_items.json
  def create
   # @cart_item = CartItem.new(params[:cart_item])
    @cart = current_cart #references the current cart which was defined in application controller
    sku = Sku.find(params[:cart_item][:sku_id])
    @cart_item = @cart.add_cart_item(sku.weight, sku.price, sku.id, params[:cart_item][:quantity]) #uses add_cart_item method in cart.rb to check if the cart item already exists in the cart and responds accordingly
    respond_to do |format|
      if @cart_item.save
        format.html { redirect_to root_url, notice: 'Successfully added the product to the cart.' } #redirects to cart item within the cart
        format.json { render json: @cart_item, status: :created, location: @cart_item }
        format.js { render :partial => 'carts/update_cart', :formats => [:js] }
      else
        format.html { render action: "new" }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
      respond_to do |format|
        if @cart_item.update_attributes(params[:cart_item])
          if @cart_item.quantity == 0 
            @cart_item.destroy
          end
          format.js { render :partial => 'carts/update_cart', :format => [:js] }
          format.json { head :no_content }
        else
          format.json { render json: @category.errors, status: :unprocessable_entity }
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
