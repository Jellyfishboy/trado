module StockHelper

    def latest_stock_adjustment stock_adjustment, sku
        return "td-green" if stock_adjustment == sku.stock_adjustments.active.first
    end
end