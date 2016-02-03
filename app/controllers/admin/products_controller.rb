class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    clean_drafts
    @products = Product.active.load
    @categories = Category.joins(:products).group('categories.id').all
  end

  def new
    get_associations
    @product = Product.new
    @product.save(validate: false)
    redirect_to edit_admin_product_path(@product)
  end

  def edit
    get_associations
    set_product
    set_skus
  end

  def update
    get_associations
    set_product
    set_skus
    @product.attributes = params[:product]
    @product.save(validate: false)
    if params[:commit] == "Save"
      @product.status = :draft
      params[:product][:status] = 'draft'
      @message = "Your product has been saved successfully as a draft."
    elsif params[:commit] == "Publish"
      @product.status = :published
      params[:product][:status] = 'published'
      @message = "Your product has been published successfully. It is now live in your store."
    end
    if @product.update(params[:product])
      Tag.add(params[:taggings], @product.id)
      Tag.del(params[:taggings], @product.id)
      flash_message :success, @message
      redirect_to admin_products_url
    else
      render action: "edit"
    end
  end

  # Destroying a product
  #
  def destroy
    @product = Product.find(params[:id])
    CartItem.where(sku_id: @product.skus.pluck(:id)).destroy_all unless @product.carts.empty?
    if @product.orders.empty? 
      @product.destroy
    else
      @product.skus.map { |s| Store.inactivate!(s) }
      Store.inactivate!(@product)
    end

    flash_message :success, "Product was successfully deleted."
    redirect_to admin_products_url
  end

  private

  def get_associations
    @accessories = Accessory.active.load
    @products = Product.active.published.load
    @categories = Category.all
  end

  def clean_drafts
    Product.where("name = :blank_value OR name IS :nil_value OR sku = :blank_value OR sku IS :nil_value OR part_number = :nil_value", nil_value: nil, blank_value: '').destroy_all
  end

  def set_product
    @product = Product.includes(:skus, :accessories, :attachments, :variant_types).find(params[:id])
  end

  def set_skus
    @skus = @product.skus.includes(:variants, :stock_adjustments).active.order(code: :asc)
  end
end
