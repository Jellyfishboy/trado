class Admin::ProductsController < ApplicationController

  before_action :get_associations, except: [:index, :destroy]
  before_action :authenticate_user!
  layout 'admin'

  def index
    @products = Product.active.load
    @categories = Category.joins(:products).group('categories.id').all
    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  def new
    @product = Product.new
    unless AttributeType.any?
      redirect_to admin_products_url
      flash_message :error, "You must have at least one Attribute type record before creating your first product. Create one #{view_context.link_to 'here', new_admin_products_skus_attribute_type_path}.".html_safe
    end
  end

  def edit
    @product = Product.includes(:skus, :accessories, :attachments).where(:skus => { active:true }).find(params[:id])
  end

  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        Tag.add(params[:taggings], @product.id)
        format.js { render :js => "window.location.replace('#{category_product_url(@product.category, @product)}');"}
      else
        format.json { render :json => { :errors => @product.errors.full_messages}, :status => 422 }  
      end
    end
  end

  def update
    @product = Product.includes(:skus).where(:skus => { active:true }).find(params[:id])
    respond_to do |format|
      if @product.update(params[:product])
        Attachment.set_default(params[:default_attachment])
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
      @products = Product.all
      @categories = Category.all
    end
end
