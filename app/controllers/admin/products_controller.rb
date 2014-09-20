class Admin::ProductsController < ApplicationController

  before_action :get_associations, except: [:index, :destroy]
  before_action :clean_drafts, only: :index
  before_action :authenticate_user!
  before_action :set_product, only: [:edit, :update]
  layout 'admin'

  def index
    @products = Product.active.load
    @categories = Category.joins(:products).group('categories.id').all
  end

  def new
    unless AttributeType.any?
      redirect_to admin_products_url
      flash_message :error, "You must have at least one attribute type record before creating your first product. Create one #{view_context.link_to 'now', new_admin_products_skus_attribute_type_path}.".html_safe
    else
      @product = Product.create
      redirect_to edit_admin_product_path(@product)
    end
  end

  def edit

  end

  def update
    @product.attributes = params[:product]
    @product.save(validate: false)
    if params[:commit] == "Save"
      @product.status = :draft
      @message = "Your product has been saved successfully as a draft."
    elsif params[:commit] == "Publish"
      @product.status = :published
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
      @product.skus.map { |s| Store::inactivate!(s) }
      Store::inactivate!(@product)
    end

    flash_message :success, "Product was successfully deleted."
    redirect_to admin_products_url
  end

  private

    def get_associations
      @accessories = Accessory.active.load
      @products = Product.published.load
      @categories = Category.all
    end

    def clean_drafts
      Product.where('name IS NULL').where('sku IS NULL').where('part_number IS NULL').destroy_all
    end

    def set_product
      @product = Product.includes(:skus, :accessories, :attachments).find(params[:id])
    end
end
