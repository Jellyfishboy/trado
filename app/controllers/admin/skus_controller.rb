class Admin::SkusController < ApplicationController

  before_action :set_product
  before_action :set_sku, except: [:edit, :new, :create]
  before_action :authenticate_user!

  def new
    @form_sku = @product.skus.build
    @variant = @form_sku.variants.build
    render partial: 'admin/products/skus/new_edit', format: [:js]
  end

  def create
    @form_sku = @product.skus.build(params[:sku])
    respond_to do |format|
      if @form_sku.save
        format.js { render partial: 'admin/products/skus/create', format: [:js] }
      else
        format.json { render json: { errors: @form_sku.errors.full_messages }, status: 422 }
      end
    end
  end

  def edit
    @form_sku = Sku.find(params[:id])
    render partial: 'admin/products/skus/new_edit', format: [:js]
  end

  # Updating a SKU
  #
  # If the SKU is not associated with orders, update the current record.
  # Else create a new SKU with the new attributes with the id of the parent product.
  # Set the old SKU as inactive. (It is now archived for reference by previous orders).
  # Delete any cart items associated with the old sku.
  def update
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

  # Destroying a SKU
  #
  def destroy
    Store.active_archive(CartItem, :sku_id, @sku)
    render partial: "admin/products/skus/destroy", format: [:js]
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_sku
    @sku = Sku.find(params[:id])
  end
end
