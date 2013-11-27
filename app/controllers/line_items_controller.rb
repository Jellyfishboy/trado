class LineItemsController < ApplicationController

  # POST /line_items
  # POST /line_items.json
  def create
   # @line_item = LineItem.new(params[:line_item])
    @cart = current_cart #references the current cart which was defined in application controller
    product = Product.find(params[:product_id]) #finds the product by the ID within the URL
    dimension = Dimension.find(params[:line_item][:dimension_id])
    @line_item = @cart.add_product(product.id, dimension.price, dimension.id, dimension.length, dimension.thickness, dimension.weight, product.sku) #uses add_product method in cart.rb to check if the line item already exists in the cart and responds accordingly
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url, notice: 'Successfully added the product to the cart.' } #redirects to line item within the cart
        format.json { render json: @line_item, status: :created, location: @line_item }
        session[:counter] = 0 #upon adding to cart, reset the session counter to 1
        format.js { render :partial => 'line_items/new_line_item', :formats => [:js] }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
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
        format.js { render :partial => 'line_items/new_line_item', :formats => [:js] }
        format.json { head :no_content }
      end
    end
  end  
end
