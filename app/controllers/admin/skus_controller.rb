class Admin::SkusController < ApplicationController
  before_action :authenticate_user!

  def new
    set_product
    unless @product.skus.active.empty?
      @form_sku = @product.skus.build
      @variant = @form_sku.variants.build
      render json: { modal: render_to_string(partial: 'admin/products/skus/modal', locals: { url: admin_product_skus_path, method: 'POST' }) }, status: 200
    end
  end

  def create
    set_product
    unless @product.skus.active.empty?
      @form_sku = @product.skus.build(params[:sku])
      if @form_sku.save
        if @product.skus.count == 1
            render json: { last_record: true, table: render_to_string(partial: 'admin/products/skus/table') }, status: 200
        else
            render json: { last_record: false, row: render_to_string(partial: 'admin/products/skus/single'), sku_id: @form_sku.id }, status: 200
        end
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
      Store::inactivate!(@sku)
      @old_sku = @sku
      @sku = Sku.new(params[:sku])
      @sku.product_id = @old_sku.product.id
    end

    respond_to do |format|
      if @sku.update(params[:sku])
        if @old_sku
          @old_sku.stock_adjustments.each do |sa|
            new_stock_adjustment = sa.dup
            new_stock_adjustment.sku_id = @sku.id
            new_stock_adjustment.save!
          end
          @old_sku.variants.each do |variant|
            new_variant = variant.dup
            new_variant.sku_id = @sku.id
            new_variant.save!
          end
          CartItem.where('sku_id = ?', @old_sku.id).destroy_all 
        end
        format.js { render partial: 'admin/products/skus/update', format: [:js] }
      else
        @form_sku = @old_sku ||= Sku.find(params[:id])
        Store::activate!(@form_sku)
        @form_sku.attributes = params[:sku]
        format.json { render json: { errors: @sku.errors.full_messages}, status: 422 }
      end
    end
  end

  def destroy
    set_product
    set_sku
    archive_sku_and_associated
    sku_id = @sku.id
    if @product.skus.active.empty?
      render json: { last_record: true, html: '<div class="helper-notification"><p>You do not have any variants for this product.</p><i class="icon-tags"></i></div>' }, status: 200
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
