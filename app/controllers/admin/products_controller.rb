class Admin::ProductsController < Admin::AdminBaseController
  before_action :authenticate_user!
  layout 'admin'

  def index
    clean_drafts
    set_products
    set_categories
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
    set_attachments
  end

  def update
    get_associations
    set_product
    set_skus
    set_attachments
    @product.attributes = params[:product]
    @product.save(validate: false)
    if params[:commit] == "Save"
      @product.status = :draft
      params[:product][:status] = 'draft'
      @message = t('controllers.admin.products.update.draft')
    elsif params[:commit] == "Publish"
      @product.status = :published
      params[:product][:status] = 'published'
      @message = t('controllers.admin.products.update.publish')
    end
    if @product.update(params[:product])
      Tag.add(params[:taggings], @product.id)
      Tag.del(params[:taggings], @product.id)
      flash_message :success, @message
      redirect_to admin_products_url
    else
      @product.update_column(:status, 0) if @product.published?
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

    flash_message :success, t('controllers.admin.products.destroy.valid')
    redirect_to admin_products_url
  end

  def autosave
    set_simple_product
    if @product.update(params[:product])
      render json: { }, status: 200
    else
      render json: { }, status: 422
    end
  end

  def archive
    set_simple_product
    @product.archived!
    flash_message :success, t('controllers.admin.products.archive.valid')
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
    @product ||= Product.includes(:skus, :accessories, :attachments, :variant_types, :attachments).find(params[:id])
  end

  def set_simple_product
    @product = Product.find(params[:id])
  end

  def set_products
    @products = Product.includes(:category, :active_skus, :active_sku_variants).active.load
  end

  def set_categories
    @categories = Category.joins(:products).group('categories.id').all
  end

  def set_attachments
    @attachments ||= @product.attachments.includes(:attachable)
  end

  def set_skus
    @skus ||= @product.skus.includes(:variants, :stock_adjustments).active.order(code: :asc)
  end
end
