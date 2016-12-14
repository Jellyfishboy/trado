class Admin::SkusController < Admin::AdminBaseController
  before_action :authenticate_user!

  def new
    set_product
    unless @product.active_skus.empty?
      @form_sku = @product.skus.build
      @variant = @form_sku.variants.build
      render json: { modal: render_to_string(partial: 'admin/products/skus/modal', locals: { url: admin_product_skus_path, method: 'POST' }) }, status: 200
    end
  end

  def create
    set_product
    unless @product.active_skus.empty?
      @form_sku = @product.skus.build(params[:sku])
      if @form_sku.save
        render json: { row: render_to_string(partial: 'admin/products/skus/single', locals: { sku: @form_sku }), sku_id: @form_sku.id }, status: 201
      else
        render json: { errors: @form_sku.errors.full_messages }, status: 422
      end
    end
  end

  def edit
    set_product
    @form_sku = Sku.find(params[:id])
    render json: { modal: render_to_string(partial: 'admin/products/skus/modal', locals: { url: admin_product_sku_path, method: 'PATCH' }) }, status: 200
  end

  # Updating a SKU
  #
  # If the SKU is not associated with orders, update the current record.
  # Else create a new SKU with the new attributes with the id of the parent product.
  # Set the old SKU as inactive. (It is now archived for reference by previous orders).
  # Delete any cart items associated with the old sku.
  def update
    set_product
    set_sku
    unless @sku.orders.empty?
      Store.inactivate!(@sku)
      @old_sku = @sku
      @sku = Sku.new
      params[:sku].delete(:variants_attributes)
      # change sku form to still pass the code and stock but cant edit if already have orders
      @sku.stock = @old_sku.stock
      @sku.code = @old_sku.code
      ###
    end
    # duplicate true to allow sku duplicates to bypass new record callbacks and validation
    @sku.attributes = params[:sku].merge(duplicate: true)
    @sku.product_id = @old_sku.product.id if @old_sku

    if @sku.save
      if @old_sku
        @old_sku.stock_adjustments.each do |sa|
          new_stock_adjustment = sa.dup
          new_stock_adjustment.sku_id = @sku.id
          new_stock_adjustment.duplicate = true
          new_stock_adjustment.save!
        end
        @old_sku.variants.each do |variant|
          new_variant = variant.dup
          new_variant.sku_id = @sku.id
          new_variant.save!
        end
        CartItem.where(sku_id: @old_sku.id).destroy_all 
      end
      render json: { row: render_to_string(partial: 'admin/products/skus/single', locals: { sku: @sku }), sku_id: @sku.id }, status: 200
    else
      @form_sku = @old_sku ||= Sku.find(params[:id])
      Store.activate!(@form_sku)
      @form_sku.attributes = params[:sku]
      render json: { errors: @sku.errors.full_messages }, status: 422
    end
  end

  def destroy
    set_product
    set_sku
    archive_sku_and_associated
    sku_id = @sku.id
    if @product.active_skus.empty?
      render json: { last_record: true }, status: 200
    else
      render json: { last_record: false, sku_id: sku_id }, status: 200
    end
  end

  private

  def archive_sku_and_associated
    Store.active_archive(CartItem, :sku_id, @sku)
  end

  def set_product
    @product ||= Product.find(params[:product_id])
  end

  def set_sku
    @sku ||= Sku.find(params[:id])
  end
end
