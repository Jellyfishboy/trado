module Utilities

    # Select an item from the Chosen JS dropdown plugin
    #
    def select_from_chosen item_text, options
        field = find_field(options[:from], visible: false)
        option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
        page.execute_script("$('##{field[:id]}').val('#{option_value}')")
        page.execute_script("$('##{field[:id]}').trigger('liszt:updated').trigger('change')")
    end

    # Stubs the application controller helper method, current cart with the cart object parameter
    #
    def stub_current_cart cart
        controller.stub(:current_cart).and_return(cart)
    end
end