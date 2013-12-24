class ProductsController < ApplicationController

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @line_item = LineItem.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  def update_dimension
    render :partial => 'products/update_dimension', :format => [:js], :locals => { :dimension_id => params[:dimension_id] } 
  end

end
