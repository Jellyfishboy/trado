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
    unless Tier.all.count > 0
      flash[:error] = "You do not currently have any shipping tiers. Please add a shipping tier before creating a product."
    end
    respond_to do |format|
      format.html # new.html.erb
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
        format.html { redirect_to [@product.category, @product], notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO: This update procedure needs to completed. It is all working apart from the attachment and tagging relations need to be 
  # attached to the SKU and not the product. Due to extended complexity for this action, it will be postponed to a later release.
  #######################
  # If the product is not associated with orders, update the current record.
  # Else create a new product with the new attributes.
  # Duplicate all 'active' skus and attach to the new product
  # Remove any old skus which have no associated orders
  # Set the old product and it's skus as inactive. (It is now archived for reference by previous orders)
  #######################
  # Updating a product
  # 
  # You can only update specific attributes when a product is associated with orders.
  def update
    @product = Product.find(params[:id])

    # unless @product.orders.empty?
    #   @product.inactivate!
    #   @product = Product.new(params[:product])
    #   @old_product = Product.find(params[:id])
    # end

    respond_to do |format|
      if @product.update_attributes(params[:product])
        # if @old_product
        #   @old_product.skus.active.each do |sku|
        #     @new_sku = sku.dup
        #     @new_sku.product_id = @product.id
        #     sku.inactivate!
        #     @new_sku.save
        #   end
        #   @old_product.skus.includes(:order_items).where(:order_items => { :sku_id => nil } ).destroy_all
        # end
        format.html { redirect_to admin_products_url, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        # @old_product.activate! if @old_product
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
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
