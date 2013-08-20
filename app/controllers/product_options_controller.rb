class ProductOptionsController < ApplicationController
  layout 'admin'
  # GET /product_options
  # GET /product_options.json
  def index
    @product_options = ProductOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product_options }
    end
  end

  # GET /product_options/1
  # GET /product_options/1.json
  def show
    @product_option = ProductOption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_option }
    end
  end

  # GET /product_options/new
  # GET /product_options/new.json
  def new
    @product_option = ProductOption.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_option }
    end
  end

  # GET /product_options/1/edit
  def edit
    @product_option = ProductOption.find(params[:id])
  end

  # POST /product_options
  # POST /product_options.json
  def create
    @product_option = ProductOption.new(params[:product_option])

    respond_to do |format|
      if @product_option.save
        format.html { redirect_to product_options_url, notice: 'Product option was successfully created.' }
        format.json { render json: @product_option, status: :created, location: @product_option }
      else
        format.html { render action: "new" }
        format.json { render json: @product_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_options/1
  # PUT /product_options/1.json
  def update
    @product_option = ProductOption.find(params[:id])

    respond_to do |format|
      if @product_option.update_attributes(params[:product_option])
        format.html { redirect_to @product_option, notice: 'Product option was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_options/1
  # DELETE /product_options/1.json
  def destroy
    @product_option = ProductOption.find(params[:id])
    @product_option.destroy

    respond_to do |format|
      format.html { redirect_to product_options_url }
      format.json { head :no_content }
    end
  end
end
