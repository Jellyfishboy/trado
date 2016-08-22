class Admin::Products::StockAdjustmentsController < ApplicationController
    layout 'admin'

    def new
        set_skus
        new_stock_adjustment
    end

    def create
        set_skus
        if create_stock_adjustments
            flash_message :success, 'Stock adjustments was successfully created.'
            redirect_to admin_products_stock_index_url
        else
            render :new
        end
    end

    private

    def set_skus
        @skus ||= Sku.includes(:product, :variants).complete.active.all
    end

    def new_stock_adjustment
        @stock_adjustment ||= StockAdjustment.new
    end

    def create_stock_adjustments
        StockAdjustment.create(params[:stock_adjustment])
    end
end