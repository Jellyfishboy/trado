class ProductsController < ApplicationController

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @category = @product.categories.first
    @line_item = LineItem.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end
  
  def update_price 
    @price = Dimension.where('id = ?', params[:dimension_id]).first
    render :partial => "products/update_price", :object => @price
  end
end
