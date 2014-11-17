class Admin::Products::StockController < ApplicationController
    before_action :authenticate_user!
    layout 'admin'

    def index
        @skus = Sku.includes(:product).active.all
    end

    def show
        @sku = Sku.includes(:product).active.find(params[:id])
        @stock_level = @sku.stock_levels.build
    end
end