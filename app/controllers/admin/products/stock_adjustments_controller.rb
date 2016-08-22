class Admin::Products::StockAdjustmentsController < ApplicationController
    layout 'admin'

    def new
        set_skus
        new_stock_adjustment
    end

    def create
        set_skus
    end

    private

    def set_skus
        @skus ||= Sku.includes(:product, :variants).complete.active.all
    end

    def new_stock_adjustment
        @stock_adjustment ||= StockAdjustment.new
    end
end