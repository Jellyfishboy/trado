class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
   # @line_item = LineItem.new(params[:line_item])
    @cart = current_cart #references the current cart which was defined in application controller
    product = Product.find(params[:product_id]) #finds the product by the ID within the URL
    @line_item = @cart.add_product(product.id, product.price) #uses add_product method in cart.rb to check if the line item already exists in the cart and responds accordingly

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

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])


   respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
