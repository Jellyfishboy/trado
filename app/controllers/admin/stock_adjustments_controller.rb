class Admin::StockAdjustmentsController < Admin::AdminBaseController
  before_action :authenticate_user!
  
  # New stock level
  #
  # Modal trigger for displaying a form to create a stock adjustment 
  def new 
    set_product
    set_sku
    @stock_adjustment = @sku.stock_adjustments.build
    render json: { modal: render_to_string(partial: 'admin/products/skus/stock_adjustments/modal', locals: { url: admin_product_sku_stock_adjustments_path, method: 'POST' }) }, status: 200
  end

  def create
    set_product
    set_sku
    @stock_adjustment = @sku.stock_adjustments.build(params[:stock_adjustment])
    if @stock_adjustment.save
      render json: { row: render_to_string(partial: 'admin/products/skus/stock_adjustments/single', locals: { stock_adjustment: @stock_adjustment }), sku_name: @sku.full_sku }, status: 201 
    else
      render json: { errors: @stock_adjustment.errors.full_messages }, status: 422
    end
  end

  private

  def set_sku
    @sku = @product.skus.find(params[:sku_id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end
end