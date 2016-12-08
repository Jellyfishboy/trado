module StockAdjustmentHelper
    
    def remove_stock_adjustment_fields name, f
        f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
    end
  
    def add_stock_adjustment_fields name, f, association
        new_object = f.object.class.reflect_on_association(association).klass.new
        fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
            render("fields", f: f)
        end
        link_to_function(name, "addStockAdjustmentfields(\"#{association}\", \"#{escape_javascript(fields)}\")")
    end
end