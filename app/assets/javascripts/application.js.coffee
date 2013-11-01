#= require jquery
#= require jquery_ujs

$(document).ready ->
    $('#line_item_dimension_id').change ->
        console.log $(@).val()
        $.ajax '/update_price',
            type: 'GET'
            data: {'dimension_id' : $('#line_item_dimension_id').val() }
            dataType: 'html'
            success: (data) ->
                $('.price').html data
