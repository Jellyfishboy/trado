class ProductsController < ApplicationController

  before_filter :authenticate_user!, :except => :show
  layout 'admin', :except => [:show]
  # GET /products
  # GET /products.json
  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

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

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])
    @dimension = Dimension.new
    binding.pry
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    #FIXME: Not adhering to the DRY principle.
    @product.attributes = {'accessory_ids' => []}.merge(params[:product] || {})
    @product.attributes = {'category_ids' => []}.merge(params[:product] || {})
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    begin
      @product.destroy
      flash[:success] = "Successfully deleted the product."
    rescue ActiveRecord::DeleteRestrictionError => e
      @product.errors.add(:base, e)
      flash[:error] = "#{e}"
    end
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def update_price 
    @price = Dimension.where('id = ?', params[:dimension_id]).first
    render :partial => "products/update_price", :object => @price
  end
end
