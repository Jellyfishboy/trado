class Admin::Products::StockAdjustmentsController < ApplicationController
    layout 'admin'

    def new
        set_skus
        new_stock_adjustment
    end

    def create
        set_skus
        set_collection
        respond_to do |format|
            format.html do
                StockAdjustment.create(@collection)
                flash_message :success, t('controllers.admin.products.stock_adjustments.create.valid')
                redirect_to admin_products_stock_index_url
            end

            format.json do
                if StockAdjustment.valid_collection?(@collection)
                    render json: {  }, status: 200
                else
                    render json: { errors: [t('controllers.admin.products.stock_adjustments.create.invalid')] }, status: 422
                end
            end
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

    def set_collection
        @collection = params[:sku][:stock_adjustments_attributes].map(&:last).reject{|s| s[:_destroy] == "1"}
    end
end