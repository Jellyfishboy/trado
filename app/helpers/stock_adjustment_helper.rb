module StockAdjustmentHelper
    
    def remove_stock_adjustment_fields name, f
        f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    end
  
    def add_stock_adjustment_fields name, f
        new_object = f.object.stock_adjustments.new
        fields = f.fields_for(:stock_adjustments, new_object, child_index: "sku_stock_adjustments") do |builder|
            render("fields", f: builder)
        end
        link_to_function(name, "addStockAdjustmentfields(\"#{escape_javascript(fields)}\")")
    end
end