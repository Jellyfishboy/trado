class Admin::Products::StockController < Admin::AdminBaseController
    before_action :authenticate_user!
    layout 'admin'

    def index
        @skus = Sku.includes(:product).complete.active.all
    end

    def show
        @sku = Sku.includes(:product).active.find(params[:id])
        @stock_adjustments = @sku.stock_adjustments.active
        @stock_adjustment = @sku.stock_adjustments.build
    end
end