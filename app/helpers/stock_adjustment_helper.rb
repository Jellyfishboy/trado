module StockAdjustmentHelper
    
    def remove_stock_adjustment_fields f
        f.hidden_field(:_destroy) + link_to_function("<i class=\"icon-close\"></i>", 'btn btn-red btn-normal', "trado.admin.removeStockAdjustmentFields(this)")
    end
  
    def add_stock_adjustment_fields f
        new_object = f.object.stock_adjustments.new
        fields = f.fields_for(:stock_adjustments, new_object, child_index: "sku_stock_adjustments") do |builder|
            render("fields", f: builder)
        end
        link_to_function("<i class=\"icon-plus\"></i>", "btn btn-blue btn-large", "trado.admin.addStockAdjustmentfields(\"#{escape_javascript(fields)}\")")
    end
end