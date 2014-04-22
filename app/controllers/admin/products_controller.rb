class Admin::ProductsController < ApplicationController

  before_filter :authenticate_user!
  layout 'admin'
  # GET /products
  # GET /products.json
  def index
    @products = Product.active.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    respond_to do |format|
      unless Tier.all.count > 0 || AttributeType.all.count > 0
        format.html { redirect_to admin_products_url }
        flash[:error] = "You do not currently have any shipping tiers and/or sku attribute types. Please add one before creating a product."
      else
        format.html
      end
      format.json { render json: @product }
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        Store::Tags.add(params[:taggings], @product.id)
        format.js { render :js => "window.location.replace('#{category_product_url(@product.category, @product)}');"}
      else
        format.json { render :json => { :errors => @product.errors.full_messages}, :status => 422 }  
      end
    end
  end

  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update_attributes(params[:product])
        Store::Tags.del(params[:taggings], @product.id)
        Store::Tags.add(params[:taggings], @product.id)
        format.js { render :js => "window.location.replace('#{category_product_url(@product.category, @product)}');"}
      else
        format.json { render :json => { :errors => @product.errors.full_messages}, :status => 422 } 
      end
    end
  end

  # Destroying a product
  #
  # Various if statements to handle how a product is dealt with then checking order and cart associations
  # If there are no carts or orders: destroy the product and its skus.
  # If there are orders but no carts: deactivate the product and its skus.
  # If there are carts but no orders: delete all cart items, then delete the product and its skus.
  # If there are orders and carts: deactivate the product, its skus and delete all cart items.
  def destroy
    @product = Product.find(params[:id])

    if @product.carts.empty? && @product.orders.empty?
      @product.destroy
    elsif @product.carts.empty? && !@product.orders.empty?
      @product.skus.map { |s| s.inactivate! }
      @product.inactivate!
    elsif !@product.carts.empty? && @product.orders.empty?
      CartItem.where(:sku_id, @product.skus.pluck(:id)).destroy_all
      @product.destroy
    else
      @product.skus.map { |s| s.inactivate! }
      @product.inactivate!
      CartItem.where(:sku_id, @product.skus.pluck(:id)).destroy_all
    end

    respond_to do |format|
      flash[:success] = "Product was successfully deleted."
      format.html { redirect_to admin_products_url }
    end
  end
end
