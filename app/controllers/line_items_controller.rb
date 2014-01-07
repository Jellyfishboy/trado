class LineItemsController < ApplicationController

  # POST /line_items
  # POST /line_items.json
  def create
   # @line_item = LineItem.new(params[:line_item])
    @cart = current_cart #references the current cart which was defined in application controller
    product = Product.find(params[:product_id]) #finds the product by the ID within the URL
    sku = Sku.find(params[:line_item][:sku_id])
    @line_item = @cart.add_product(product.id, sku.price, sku.id, sku.length, sku.thickness, sku.weight, sku.sku, params[:line_item][:quantity]) #uses add_product method in cart.rb to check if the line item already exists in the cart and responds accordingly
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to root_url, notice: 'Successfully added the product to the cart.' } #redirects to line item within the cart
        format.json { render json: @line_item, status: :created, location: @line_item }
        session[:counter] = 0 #upon adding to cart, reset the session counter to 1
        format.js { render :partial => 'carts/update_cart', :formats => [:js] }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @line_item = LineItem.find(params[:id])
      respond_to do |format|
        if @line_item.update_attributes(params[:line_item])
          if @line_item.quantity == 0 
            @line_item.destroy
          end
          format.js { render :partial => 'carts/update_cart', :format => [:js] }
          format.json { head :no_content }
        else
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @cart = current_cart
    line_item = LineItem.find(params[:id])
    @line_item = @cart.decrement_line_item_quantity(line_item.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url, notice: 'Successfully deleted the item.' }
        format.js { render :partial => 'carts/update_cart', :formats => [:js] }
        format.json { head :no_content }
      end
    end
  end  
end
