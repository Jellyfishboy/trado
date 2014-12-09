class Admin::StockAdjustmentsController < ApplicationController
  before_action :set_sku
  before_action :set_product
  before_action :authenticate_user!
  
  # New stock level
  #
  # Modal trigger for displaying a form to create a stock adjustment 
  def new 
    @stock_adjustment = @sku.stock_adjustments.build
    render partial: 'admin/products/skus/stock_adjustments/new', format: [:js]
  end

  def create
    @stock_adjustment = @sku.stock_adjustments.build(params[:stock_adjustment])
    respond_to do |format|
      if @stock_adjustment.save
        @stock_adjustments = @sku.stock_adjustments.active
        format.js { render partial: 'admin/products/skus/stock_adjustments/create', format: [:js] }
      else
        format.json { render json: { errors: @stock_adjustment.errors.full_messages }, status: 422 }
      end
    end
  end

  def set_sku
    @sku = Sku.find(params[:sku_id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end
end