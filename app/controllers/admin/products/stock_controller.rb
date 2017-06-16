class Admin::Products::StockController < Admin::AdminBaseController
    before_action :authenticate_user!
    layout 'admin'

    def index
        set_skus
    end

    def show
        set_sku
        set_stock_adjustments
        new_stock_adjustment
    end

    private

    def set_skus
        @skus ||= Sku.includes(:product, :variants).complete.active_non_archived.all
    end

    def set_sku
        @sku ||= Sku.includes(:product).active.find(params[:id])
    end

    def set_stock_adjustments
        @stock_adjustments = @sku.stock_adjustments.active
    end

    def new_stock_adjustment
        @stock_adjustment = @sku.stock_adjustments.build
    end
end