class Admin::StockLevelsController < ApplicationController
  before_action :set_sku
  before_action :set_product
  before_action :authenticate_user!
  
  # New stock level
  #
  # Modal trigger for displaying a form to add a stock level adjustment 
  def new 
    @stock_level = @sku.stock_levels.build
    render partial: 'admin/products/skus/stock_levels/new', format: [:js]
  end

  def create
    @stock_level = @sku.stock_levels.build(params[:stock_level])
    respond_to do |format|
      if @stock_level.save
        format.js { render partial: 'admin/products/skus/stock_levels/create', format: [:js] }
      else
        format.json { render json: { errors: @stock_level.errors.full_messages }, status: 422 }
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