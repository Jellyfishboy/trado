class Admin::Products::Skus::StockLevelsController < ApplicationController

  # New stock level
  #
  # Modal trigger for displaying a form to add a stock level adjustment 
  def new 
    @sku = Sku.find(params[:sku_id])
    @stock_level = StockLevel.new
    render :partial => 'admin/products/skus/stock_levels/new', :format => [:js]
  end

  def create
    @stock_level = StockLevel.new(params[:stock_level])
    respond_to do |format|
      if @stock_level.save
        if Store::positive?(@stock_level.adjustment)
          @stock_level.sku.update_column(:stock, @stock_level.sku.stock + @stock_level.adjustment)
        else
          @stock_level.sku.update_column(:stock, @stock_level.sku.stock - @stock_level.adjustment.abs)
        end
        format.js { render :partial => 'admin/products/skus/stock_levels/new', :format => [:js] }
      else
        format.json { render :json => { :errors => @stock_level.errors.full_messages}, :status => 422 }
      end
    end
  end

end