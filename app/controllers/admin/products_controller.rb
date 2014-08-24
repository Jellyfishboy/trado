class Admin::ProductsController < ApplicationController

  before_action :get_associations, except: [:index, :destroy]
  before_action :clean_drafts, only: :index
  before_action :authenticate_user!
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
    end
  end

  def edit
    @product = Product.includes(:skus, :accessories, :attachments).find(params[:id])
  end

  def update
    @product = Product.includes(:skus).find(params[:id])
    if 
      @product.status = :draft
    else
      @product.status = :published
    end

    respond_to do |format|
      if @product.update(params[:product])
        Tag.del(params[:taggings], @product.id)
        Tag.add(params[:taggings], @product.id)
        format.js { render :js => "window.location.replace('#{admin_products_url}');"}
      else
        format.json { render :json => { :errors => @product.errors.full_messages}, :status => 422 } 
      end
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
      Product.where(name: nil).where(sku: nil).where(part_number: nil).destroy_all
    end
end
