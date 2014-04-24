class Admin::Products::Skus::StockLevelsController < ApplicationController

  before_filter :authenticate_user!
  # New stock level
  #
  # Modal trigger for displaying a form to add a stock level adjustment 
  def new 
    render :partial => 'admin/products/skus/stock_levels/new', :format => [:js]
  end

  def create
    @stock_level = StockLevel.new(params[:stock_level])
    respond_to do |format|
      if @stock_level.save
        @sku = @stock_level.sku
        format.js { render :partial => 'admin/products/skus/stock_levels/success', :format => [:js] }
      else
        format.json { render :json => { :errors => @stock_level.errors.full_messages }, :status => 422 }
      end
    end
  end

end